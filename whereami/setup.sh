export PROJECT_ID=murriel-boutique-demo
export COMPUTE_REGION=us-west1
export CLUSTER_NAME=cicd-demo

printf "\nProject ID: $PROJECT_ID\nRegion: $COMPUTE_REGION\nCluster Name: $CLUSTER_NAME\n\n"


gcloud --project ${PROJECT_ID} container clusters \
  create-auto ${CLUSTER_NAME} --region ${COMPUTE_REGION} \
  --release-channel regular --async

kustomize build whereami/k8s > whereami-cicd/whereami.yaml

kubectl apply -f whereami-cicd/namespaces.yaml 