#!/bin/bash
set -e

NAMESPACE="project-monitoring"
RELEASE="project-dev-3"
CHART_PATH="./project-dev-3"

echo "Creating namespace if not exists..."
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

echo "Adding Prometheus Helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "Installing kube-prometheus-stack..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace $NAMESPACE \
  --create-namespace \
  -f prometheus-values.yaml

echo "Installing/upgrading custom Helm release ($RELEASE)..."
helm upgrade --install $RELEASE $CHART_PATH -n $NAMESPACE

echo "Waiting for all pods in $NAMESPACE to be ready..."
kubectl wait --for=condition=Ready pods --all -n $NAMESPACE --timeout=180s

echo "All Namespaces:"
kubectl get ns

echo "All Pods in $NAMESPACE:"
kubectl get pods -n $NAMESPACE

echo "Fetching index.html from nginx pod..."
NGINX_POD=$(kubectl get pods -n $NAMESPACE -l app=nginx -o jsonpath="{.items[0].metadata.name}")
kubectl exec -n $NAMESPACE "$NGINX_POD" -- curl -s http://localhost/index.html

echo "Services with NodePorts in $NAMESPACE:"
kubectl get svc -n $NAMESPACE | grep -E 'grafana|prometheus|nginx'
