# Demo for SoCal Linux Expo 2025
Based off samples in the whereami-cicd directory 

# About the Cluster (EP)
- [minikube] (https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download) 
- open docker desktop
- `minikube start` 
- you'll see the `minikube` cluster in your Docker Desktop status will read "Running"
-  in the terminal run the containerized application!

```
kubectl run --image=us-docker.pkg.dev/google-samples/containers/gke/whereami:v1.2.23 --expose --port 8080 whereami
service/whereami created
pod/whereami created
```

It's easy to get started with a local cluster!

- 

## Skaffold Basics (MM)

## Kustomize Basics (EP)

In the `whereami` application folder we have examples of using `kustomize` to deploy overlays on the k8s base layer.
Let's take a look at two!
 
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

Base: k8s/

Overlay: whereami-cicd/k8s-backend-overlay-example

```
kubectl apply -k [pattern]
```

## Helm Basics (MM)
```
helm search hub where                                                      
helm install whereami oci://us-docker.pkg.dev/google-samples/charts/whereami –version 1.2.23
```

## Using Kustomize and Helm with Skaffold (MM)