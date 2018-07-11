#!/bin/bash

if [ ! -d ./embeddings ] || [ -z "$(ls -A ./embeddings)" ]; then
  echo 'Enter results bucket name (e.g results-bucket)'
  read RESULTS_BUCKET
  RESULTS_BUCKET=$(echo $RESULTS_BUCKET|tr -d '\n')

  echo 'Enter training ID (e.g: training-1qw3sd4ds)'
  read TRAIN_ID

  echo 'Downloading word embeddings from specified bucket'
  mkdir -p embeddings
  aws --endpoint-url=http://s3-api.us-geo.objectstorage.softlayer.net s3 cp "s3://$RESULTS_BUCKET/$TRAIN_ID/col_embedding.tsv" ./embeddings/col_embedding.tsv
  aws --endpoint-url=http://s3-api.us-geo.objectstorage.softlayer.net s3 cp "s3://$RESULTS_BUCKET/$TRAIN_ID/row_embedding.tsv" ./embeddings/row_embedding.tsv

  python text2bin.py -o vecs.bin -v vocab.txt ./embeddings/*_embedding.tsv
fi

python nearest.py -v vocab.txt -e vecs.bin
