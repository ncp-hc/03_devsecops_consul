#!/bin/bash
gcloud container clusters get-credentials gs-google-gke --zone asia-northeast3-a --project gs-test-282101
kubectl config view -o json | jq -r '.contexts[].name'  > ./KCONFIG.txt
kubectl config use-context $(grep gke KCONFIG.txt)

kubectl get nodes

# helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && \
helm repo add grafana https://grafana.github.io/helm-charts && \
helm repo add hashicorp https://helm.releases.hashicorp.com && \
helm repo update

set -v

echo "applying secret for federation CA and mesh gateway address..."
kubectl apply -f ../ncloud_consul/consul-federation-secret.yaml

echo "Installing consul using latest helm chart "
helm install consul hashicorp/consul -f values.yaml --debug

sleep 10s

kubectl apply -f stubDomain.yaml

sleep 2

# kubectl delete pod --namespace kube-system -l k8s-app=kube-dns