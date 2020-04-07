#!/bin/bash

if [ "$1" == "clean" ]; then
    rm -f training-runs.yml training-runs.yml.bak
    exit 0
fi

make_bucket() {
  if [[ $(aws --endpoint-url=http://s3-api.us-geo.objectstorage.softlayer.net s3 mb s3://$1) ]]; then
    return 0
  else
    echo 'Bucket name already exists.'
    return 1
  fi
}

if [ ! -f ./swivel_training_data.zip ]; then
  echo Downloading training data
  curl -O https://max-cdn.cdn.appdomain.cloud/max-word-embedding-generator/1.0.0/swivel_training_data.zip &&
  unzip -q swivel_training_data.zip

  CREATE_SUCCESS=1
  while [[ $CREATE_SUCCESS ]]; do
    echo 'Enter a training bucket name'
    read TRAINING_BUCKET
    TRAINING_BUCKET=$(echo $TRAINING_BUCKET|tr -d '\n')
    CREATE_SUCCESS=$(make_bucket $TRAINING_BUCKET)
  done
  aws --endpoint-url=http://s3-api.us-geo.objectstorage.softlayer.net s3 cp --recursive swivel_training_data s3://$TRAINING_BUCKET

  CREATE_SUCCESS=1
  while [[ $CREATE_SUCCESS ]]; do
    echo 'Enter a training bucket name'
    read RESULTS_BUCKET
    RESULTS_BUCKET=$(echo $RESULTS_BUCKET|tr -d '\n')
    CREATE_SUCCESS=$(make_bucket $RESULTS_BUCKET)
  done
fi

if [ ! -f ./training-runs.yml ]; then
    if [ -z "$AWS_ACCESS_KEY_ID" ] || [ z- "$AWS_SECRET_ACCESS_KEY" ]; then
      echo "Please set local environment variables AWS_ACCESS_KEY_ID and/or AWS_SECRET_ACCESS_KEY"
      exit 1
    fi
    echo 'Generating training-runs.yml'
    cp ./training-runs.yml.template ./training-runs.yml
    sed -i .bak "s/    access_key_id:.*/    access_key_id: $AWS_ACCESS_KEY_ID/g" training-runs.yml
    sed -i .bak "s/    secret_access_key:.*/    secret_access_key: $AWS_SECRET_ACCESS_KEY/g" training-runs.yml
    sed -i .bak "s#TRAINING_BUCKET#$TRAINING_BUCKET#" training-runs.yml
    sed -i .bak "s#RESULTS_BUCKET#$RESULTS_BUCKET#" training-runs.yml
fi

bx ml train swivel.zip training-runs.yml
