This repository contains demos and sample code for the 
following talk at KubeCon 2024 SLC: 

[Deploy with Joy](https://events.linuxfoundation.org/kubecon-cloudnativecon-north-america/program/schedule/)

## Assumptions
You have a cluster setup and you are authenticated against the cluster with the appropriate roles granted. 

## Manual Deploy 
Three ways to manually deploy an application on Kubernetes:

1.  kubectl apply -f <yaml file> 
2. kubectl run ... 
3. 

## Skaffold 

## Kustomize 
Checkout the `kustomize.yaml` mentioned in the README!

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


## Argo
see whereami/argo


## Jenkins


## Jenkins X