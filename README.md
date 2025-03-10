This repository contains demos and sample code for the 
following talks: 

- KubeCon/CloudNativeCon 2024 SLC: 
[Deploy with Joy](https://events.linuxfoundation.org/kubecon-cloudnativecon-north-america/program/schedule/)
- SoCal Linux Expo (SCALE) 2025 Pasadena: 
[Bringing Joy to Kubernetes Deployments](https://www.socallinuxexpo.org/scale/22x/presentations/bringing-joy-kubernetes-deployments)

## Assumptions
1. You have a cluster setup and you are authenticated against the cluster with the appropriate roles granted. 
2. kubectl is set up on your terminal 

## Demo Application
The `whereami` application is a simple microservice that returns information about its environment, including the host name, IP address, and Kubernetes pod information.  It's a useful tool for demonstrating Kubernetes deployments and related CI/CD processes.  The source code and related deployment manifests are located in the `whereami` directory. 

This application was forked from  https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/main/quickstarts/whereami (Thank You's to [Alex](https://github.com/theemadnes) for most of the dev work on the app)

## Manual Deploy 
*Note: run the following in the * whereami-cicd directory*\

`cd whereami-cicd`

Three ways to manually deploy an application on Kubernetes:

1. `kubectl apply -f whereami.yaml`
2. `kubectl apply -f whereami/`

3. `kubectl run \ --image=us-docker.pkg.dev/google-samples/containers/gke/whereami:v1.2.23 \ --expose --port 8080 whereami`
4. Push a yaml config via the command line
```
$ cat << EOF | kubectl create -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-deploy
  template:
    metadata:
      labels:
        app: hello-deploy
    spec:
      containers:
      - name: hello-deploy
        image: gcr.io/google-samples/whereami:v1.2.23
        ports:
        - containerPort: 8080
EOF
```


## Skaffold 

see whereami/skaffold

In this folder is an example of a skaffold.yaml file to deploy the whereami application to Kubernetes. This file assumes that you have a Dockerfile for building the application image and Kubernetes manifests for deploying the application.

`skaffold.yaml` Explanation

apiVersion: Specifies the Skaffold API version.
kind: Specifies the kind of configuration (Config).
metadata:
    name: The name of the Skaffold project.
build:
    artifacts: Defines the build artifacts.
        image: The name of the Docker image to build.
        context: The build context directory.
        docker:
            dockerfile: The path to the Dockerfile.
    local:
        push: Specifies whether to push the image to a remote registry (set to false for local development).
deploy:
    kubectl:
        manifests: A list of Kubernetes manifest files to deploy.

Prerequisites

+ Dockerfile: Ensure you have a Dockerfile for building the whereami application.
+ Kubernetes Manifests: Ensure you have Kubernetes manifests (e.g., deployment.yaml and service.yaml) for deploying the application in the k8s directory.

Make sure to replace your-docker-registry/whereami:latest with your actual Docker registry URL and image tag. Adjust the paths and configurations as needed for your environment.


## Kustomize 
Checkout the `kustomize.yaml` mentioned in the `whereami/README`!

The k8s deployment repo uses Kustomize to organize its deployment files. The following command will deploy the all of the required resources for the full `whereami` deployment.

```bash
$ cat k8s/kustomization.yaml
resources:
- ksa.yaml
- deployment.yaml
- service.yaml
- configmap.yaml

$ kubectl apply -k k8s
serviceaccount/whereami created
configmap/whereami created
service/whereami created
deployment.apps/whereami created
```

....

## Helm
see whereami/helm-chart  

## Tekton
see whereami/tekton

Here's a step-by-step plan to create a Tekton pipeline to deploy the whereami application to Kubernetes:

Create a Tekton Task to build the Docker image:
+ Use a kaniko task to build the Docker image from the source code.
+ Push the Docker image to a container registry.

Create a Tekton Task to deploy the Docker image to Kubernetes:
+ Use a kubectl task to apply the Kubernetes manifests.

Create a Tekton Pipeline to link the tasks:
+ Define the pipeline to run the build task first and then the deploy task.

Create a PipelineRun to execute the pipeline:
+ Provide the necessary parameters and resources.

Make sure to replace gcr.io/your-project/whereami:latest with your actual image name and your-pvc with your actual PVC name. Also, ensure that your Kubernetes manifests are correctly placed in the k8s directory within your source code repository.

## Argo
see whereami/argo

This manifest assumes that you have a Kubernetes manifest for the whereami application stored in a Git repository.

Argo CD Application Manifest
argocd

Explanation

metadata:

+ name: The name of the Argo CD application.
+ namespace: The namespace where Argo CD is installed (usually argocd).

spec:

+ project: The Argo CD project to which this application belongs (default is default).
+ source:
    + repoURL: The URL of the Git repository containing the Kubernetes manifests.
    + targetRevision: The Git branch, tag, or commit to deploy (e.g., HEAD for the latest commit on the default branch).
    + path: The path within the repository where the Kubernetes manifests are located (e.g., k8s).

destination:
    + server: The Kubernetes API server URL (use https://kubernetes.default.svc for in-cluster).
    + namespace: The Kubernetes namespace where the application will be deployed (e.g., default).
syncPolicy:
    + automated: Enables automated synchronization.
    + prune: Automatically delete resources that are no longer defined in the Git repository.
    + selfHeal: Automatically sync the application if it deviates from the desired state.
syncOptions: Additional synchronization options.
    + CreateNamespace=true: Automatically create the namespace if it does not exist.

Make sure to replace https://github.com/your-repo/whereami.git with the actual URL of your Git repository and adjust the path if your Kubernetes manifests are located in a different directory.

## Jenkins

Below is an example of a Jenkins pipeline script (Jenkinsfile) to deploy the whereami application to Kubernetes. This script assumes that you have a Dockerfile for building the application image and Kubernetes manifests for deploying the application.

Jenkinsfile Explanation

environment:

+ REGISTRY: The Docker registry where the image will be pushed.
+ IMAGE_NAME: The name of the Docker image.
+ IMAGE_TAG: The tag for the Docker image.
+ KUBECONFIG_CREDENTIALS_ID: The Jenkins credentials ID for the Kubernetes config file.

stages:

+ Checkout: Checks out the source code from the SCM (Source Control Management).
+ Build Docker Image: Builds the Docker image using the Dockerfile in the repository.
+ Push Docker Image: Pushes the Docker image to the specified Docker registry.
+ Deploy to Kubernetes: Deploys the application to Kubernetes using kubectl apply and the Kubernetes manifests in the k8s directory.

post:

+ always: Cleans up the workspace after the pipeline run.

Prerequisites

+ Docker Credentials: Ensure you have Docker credentials configured in Jenkins with the ID docker-credentials.
+ Kubeconfig Credentials: Ensure you have Kubernetes config file credentials configured in Jenkins with the ID kubeconfig-credentials.
+ Kubernetes Manifests: Ensure your Kubernetes manifests (e.g., deployment.yaml) are located in the k8s directory within your repository.

Make sure to replace your-docker-registry with your actual Docker registry URL. Adjust the paths and credentials IDs as needed for your environment.


## Jenkins X

see whereami/jenkins-x 

Below is an example of a Jenkins X pipeline configuration file (jenkins-x.yml) to deploy the whereami application to Kubernetes. This file assumes that you have a Dockerfile for building the application image and Kubernetes manifests for deploying the application.

jenkins-x.yml Explanation

pipelineConfig:
    pipelines:
        release:
            pipeline:
                agent: Specifies the Jenkins X agent to use.
                stages: Defines the stages of the pipeline.
                    build: Builds the application using a make build command.
                    test: Runs tests using a make test command.
                    buildDockerImage: Builds the Docker image using a make docker-build command.
                    pushDockerImage: Pushes the Docker image to the registry using a make docker-push command.
                    deploy: Deploys the application to Kubernetes using Helm.
                        helmBuild: Builds the Helm chart.
                        helmApply: Applies the Helm chart to the Kubernetes cluster.
                        env: Sets the environment variable DEPLOY_NAMESPACE to specify the namespace for deployment.

Prerequisites

Makefile: Ensure you have a Makefile with the following targets:

+ build: Builds the application.
+ test: Runs the tests.
+ docker-build: Builds the Docker image.
+ docker-push: Pushes the Docker image to the registry.
+ Helm Chart: Ensure you have a Helm chart for the whereami application.

Jenkins X Environment: Ensure you have a Jenkins X environment set up with the necessary configurations.

Make sure to replace your-docker-registry with your actual Docker registry URL. Adjust the paths and commands as needed for your environment.