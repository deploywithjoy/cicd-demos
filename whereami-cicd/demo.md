# Demo for SoCal Linux Expo 2025
Based off samples in the whereami-cicd directory 

# About the Cluster (EP)
- [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download) 
- open docker desktop
- `minikube start` 
- you'll see the `minikube` cluster in your Docker Desktop status will read "Running"
-  in the terminal run the containerized application!

> **OPTION:**  
> To run Minikube using podman and cri-o:\
> `minikube start --driver=podman --container-runtime=cri-io`

```
$ kubectl run --image=us-docker.pkg.dev/google-samples/containers/gke/whereami:v1.2.23 --expose --port 8080 whereami

  service/whereami created
  pod/whereami created

$ kubectl get pods 
$ kubectl describe pod whereami

```

It's easy to get started with a local cluster!

## Kustomize Basics (EP)

In the `whereami` application folder we have examples of using `kustomize` to deploy overlays on the k8s base layer.
Let's take a look at two!

To get a sense of what our cluster looks like before we start making changes, run a 
```
$ kubectl describe pod
```

An example deploy overlays `whereami` using the manifests from [k8s-backend-overlay-example](k8s-backend-overlay-example)

```bash
$ kubectl apply -k k8s-backend-overlay-example
serviceaccount/whereami-backend created
configmap/whereami-backend created
service/whereami-backend created
deployment.apps/whereami-backend created
```

`configmap/whereami-backend` has the following fields configured:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: whereami
data:
  BACKEND_ENABLED: "False" # assuming you don't want a chain of backend calls
  METADATA:        "backend"
```

It overlays the base manifest with the following Kustomization file:

```yaml
nameSuffix: "-backend"
labels:
- includeSelectors: true
  includeTemplates: true
  pairs:
    app: whereami-backend
resources:
- ../k8s
patches:
- path: cm-flag.yaml
  target:
    kind: ConfigMap
- path: service-type.yaml
  target:
    kind: Service
```

Check it out in the cluster 
```
$ kubectl describe pod
```
#### Step 2 - Deploy the whereami frontend

Now we're going to deploy the `whereami` frontend from the `k8s-frontend-overlay-example` folder. The configmap in this folder shows how the frontend is configured differently from the backend:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: whereami
data:
  BACKEND_ENABLED: "True" #This enables requests to be send to the backend
  # when defining the BACKEND_SERVICE using an HTTP protocol, indicate HTTP or HTTPS; if using gRPC, use the host name only
  BACKEND_SERVICE: "http://whereami-backend" #This is the name of the backend Service that was created in the previous step
  METADATA:        "frontend" #This is the metadata string returned in the output
```

Deploy the frontend:

```bash
$ kubectl apply -k k8s-frontend-overlay-example
serviceaccount/whereami-frontend created
configmap/whereami-frontend created
service/whereami-frontend created
deployment.apps/whereami-frontend created
```


Check it out in the cluster to see all the changes!
```
$ kubectl describe pod
```

Base: k8s/

Overlay: whereami-cicd/k8s-backend-overlay-example

```
kubectl apply -k [pattern]
```

## Helm Basics (MM)
- This repo's helm Charts are in [helm-chart](helm-chart)
- Search or add helm charts on [Artifact Hub](https://artifacthub.io)

```
helm search hub                              
helm search hub argocd 
```

- Search and add a repository:
```
helm repo add argo https://argoproj.github.io/argo-helm

helm search repo 

helm repo add gitlab https://charts.gitlab.io/

helm search repo --version 1.10.1 
helm search repo argo --version 1.10.1 
```
(Repos have more flexibility for searching including versions and regexp)

- Install directly from a private oci repository
```
helm show values oci://us-docker.pkg.dev/google-samples/charts/whereami --version 1.2.23

helm install whereami-remote oci://us-docker.pkg.dev/google-samples/charts/whereami --version 1.2.23

helm install whereami-local ./whereami-cicd/helm-chart --namespace helm --create-namespace

helm install whereami-be oci://us-docker.pkg.dev/google-samples/charts/whereami --version 1.2.23 \
  --set suffix=-backend,config.metadata=backend,service.type=ClusterIP

helm list --all-namespaces
helm status whereami-be -n helm 

```

## Skaffold (MM)
- Create a skaffold yaml file using `skaffold init`
- View the existing `skaffold.yaml` file
- Run `skaffold dev` to start a development environment

```
kubectl create namespace skaffold
skaffold init

```
- Using Kustomize with Skaffold 
- Using Helm with Skaffold 
