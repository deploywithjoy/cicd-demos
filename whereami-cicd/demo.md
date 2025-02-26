# Demo for SoCal Linux Expo 2025
Based off samples in the whereami-cicd directory 

# About the Cluster (EP)
- minikube 

## Skaffold Basics (MM)

## Kustomize Basics (EP)

Base: k8s/

Overlay: whereami-cicd/k8s-echo-headers-overlay-example/

```
kubectl apply -k
```

## Helm Basics (MM)
```
helm search hub where                                                      
helm install whereami oci://us-docker.pkg.dev/google-samples/charts/whereami –version 1.2.23
```

## Using Kustomize and Helm with Skaffold (MM)