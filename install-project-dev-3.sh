
#!/bin/bash
set -e

NAMESPACE="project-monitoring"
RELEASE="project-dev-3"
CHART_PATH="./project-dev-3"

echo "Creating namespace if not exists..."
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

echo "Installing/upgrading Helm release..."
helm upgrade --install $RELEASE $CHART_PATH -n $NAMESPACE --create-namespace

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n $NAMESPACE --timeout=180s

echo "All done! Pods in $NAMESPACE:"
kubectl get pods -n $NAMESPACE

echo "Services with NodePorts:"
kubectl get svc -n $NAMESPACE | grep -E 'grafana|prometheus|nginx'

echo "Finding nginx pod..."
NGINX_POD=$(kubectl get pods -n $NAMESPACE -l app=nginx -o jsonpath="{.items[0].metadata.name}")

if [ -z "$NGINX_POD" ]; then
  echo "Error: NGINX pod not found in namespace $NAMESPACE"
  exit 1
fi

echo "Curling index.html from nginx pod on internal port 80..."
kubectl exec -n $NAMESPACE "$NGINX_POD" -- curl -s http://localhost/index.html