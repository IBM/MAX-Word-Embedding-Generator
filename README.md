# IBM Code Model Asset Exchange: Word Embedding Generator

This repository contains code to generate word embeddings using the Swivel algorithm on [IBM Watson Machine Learning](https://www.ibm.com/cloud/machine-learning). This model is part of the [IBM Code Model Asset Exchange](https://developer.ibm.com/code/exchanges/models/).

Machine learning algorithms usually expect numeric inputs. When a data scientist wants to use text to create a machine learning model, they must first find a way to represent their text as a vector of numbers. These vectors are called word embeddings. The Swivel algorithm is a frequency-based word embedding that uses a co-occurence matrix. The idea here is that words that have similar meanings tend to occur together in a text corpus. As a result, words that have similar meanings will have vector representations that are closer than those of unrelated words.

This demo contains scripts to run the Swivel algorithm on a preprocessed Wikipedia text corpus.
For instructions on generating word embeddings on your own text corpus see the instructions in the
[original repository here](https://github.com/tensorflow/models/tree/master/research/swivel).

# Quickstart

## Prerequisites

* This experiment requires a provisioned instance of IBM Watson Machine Learning service.

### Setup an IBM Cloud Object Storage (COS) account
- Create an IBM Cloud Object Storage account if you don't have one (https://www.ibm.com/cloud/storage)
- Create credentials for either reading and writing or just reading
	- From the bluemix console page (https://console.bluemix.net/dashboard/apps/), choose `Cloud Object Storage`
	- On the left side, click the `service credentials`
	- Click on the `new credentials` button to create new credentials
	- In the `Add New Credentials` popup, use this parameter `{"HMAC":true}` in the `Add Inline Configuration...`
	- When you create the credentials, copy the `access_key_id` and `secret_access_key` values.
	- Make a note of the endpoint url
		- On the left side of the window, click on `Endpoint`
		- Copy the relevant public or private endpoint. [I choose the us-geo private endpoint].
- In addition setup your [AWS S3 command line](https://aws.amazon.com/cli/) which can be used to create buckets and/or add files to COS.
   - Export `AWS_ACCESS_KEY_ID` with your COS `access_key_id` and `AWS_SECRET_ACCESS_KEY` with your COS `secret_access_key`

### Setup IBM CLI & ML CLI

- Install [IBM Cloud CLI](https://console.bluemix.net/docs/cli/reference/bluemix_cli/get_started.html#getting-started)
  - Login using `bx login` or `bx login --sso` if within IBM
- Install [ML CLI Plugin](https://dataplatform.ibm.com/docs/content/analyze-data/ml_dlaas_environment.html)
  - After install, check if there is any plugins that need update
    - `bx plugin update`
  - Make sure to setup the various environment variables correctly:
    - `ML_INSTANCE`, `ML_USERNAME`, `ML_PASSWORD`, `ML_ENV`

## Training the model

The `train.sh` utility script will deploy the experiment to WML and start the training as a `training-run`

```
train.sh
```

After the train is started, it should print the training-id that is going to be necessary for steps below

```
Starting to train ...
OK
Model-ID is 'training-GCtN_YRig'
```

### Monitor the  training run

- To list the training runs - `bx ml list training-runs`
- To monitor a specific training run - `bx ml show training-runs <training-id>`
- To monitor the output (stdout) from the training run - `bx ml monitor training-runs <training-id>`
	- This will print the first couple of lines, and may time out.

## Exploring the embeddings
The `demo.sh` utility script will download the results from the bucket, convert the embeddings into binary vector format, and run a python application
to explore the embeddings:
```
demo.sh
```

When querying a single word, the results will list words that are similar in meaning.
```
query> dog
dog
dogs
cat
```

It is also possible to query to complete an analogy. (e.g. A _man_ is to a _woman_ as a _king_ is to... )
```
query> man woman king
king
queen
princess
```

## Licenses

| Component | License | Link  |
| ------------- | --------  | -------- |
| This repository | [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) | [LICENSE](LICENSE) |
| Model Code (3rd party) | [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) | [TensorFlow Models](https://github.com/tensorflow/models/blob/master/LICENSE)|
|Data|[CC BY-SA 3.0](https://en.wikipedia.org/wiki/Wikipedia:Copyrights)|[Wikipedia Text Dump](https://dumps.wikimedia.org/backup-index.html)|


# References #
[1]<a name="ref1"></a> N. Shazeer, R. Doherty, C. Evans, C. Waterson., ["Swivel: Improving Embeddings
by Noticing What's Missing"](https://arxiv.org/pdf/1602.02215.pdf) arXiv preprint arXiv:1602.02215 (2016)
