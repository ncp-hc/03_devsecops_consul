#!/bin/bash
set -v

export KUBECONFIG=./kubeconfig-39df9ca4-3c6c-4d5f-85c6-95829d01a1f6.yaml

kubectl get nodes

# helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && \
helm repo add grafana https://grafana.github.io/helm-charts && \
helm repo add hashicorp https://helm.releases.hashicorp.com && \
helm repo update

echo "Creating gossip encryption key..."
kubectl create secret generic consul-gossip-encryption-key --from-literal=key="$(consul keygen)"

echo "Installing consul using latest helm chart "
helm install consul hashicorp/consul -f values.yaml --debug

echo "As this is the primary datacenter for federation, fetch the federation secret and store in local file.."
kubectl get secret consul-federation -o yaml > consul-federation-secret.yaml


echo "Configuring Kube to forward consul DNS to consul..."

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
  name: kube-dns
  namespace: kube-system
data:
  stubDomains: |
    {"consul": ["$(kubectl get svc consul-dns -o jsonpath='{.spec.clusterIP}')"]}
EOF

sleep 10

kubectl wait --timeout=120s --for=condition=Ready $(kubectl get pod --selector=app=consul -o name)

helm install -f prometheus-values.yaml prometheus prometheus-community/prometheus --version "11.7.0" --wait
# kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm nslookup  consul.service.consul
