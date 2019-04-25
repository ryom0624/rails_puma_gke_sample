#!/bin/bash

# Exit on any error
set -e

for f in k8s/*.yaml
do
	envsubst < $f > "generated-$(basename $f)"
done
gcloud docker -- push asia.gcr.io/${PROJECT_NAME}/${CLOUD_REGISTRY_NAME}/web:$CIRCLE_SHA1
gcloud docker -- push asia.gcr.io/${PROJECT_NAME}/${CLOUD_REGISTRY_NAME}/app:$CIRCLE_SHA1
pwd
ls
kubectl apply -f generated-web.yaml --record
kubectl apply -f generated-db.yaml --record
