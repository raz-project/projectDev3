#!/bin/bash
set -e

NAMESPACE="project-monitoring"
RELEASE="project-dev-3"

# Delete permntly and dashbords will gone
# Optional: uncomment if you want full uninstall (will delete PVC)
# echo "Uninstalling Helm release..."
# helm uninstall $RELEASE -n $NAMESPACE

# Optionally delete namespace if you're done (deletes everything, including PVCs!)
# echo "Deleting namespace..."
# kubectl delete namespace $NAMESPACE
echo "Cleaning up Helm release components without losing Grafana dashboards..."

# Delete Deployments
echo "Deleting Deployments..."
kubectl delete deployment $RELEASE-grafana -n $NAMESPACE --ignore-not-found
kubectl delete deployment $RELEASE-kube-prometheus-stack-prometheus -n $NAMESPACE --ignore-not-found
kubectl delete deployment $RELEASE-kube-prometheus-stack-operator -n $NAMESPACE --ignore-not-found
kubectl delete deployment $RELEASE-kube-prometheus-stack-grafana -n $NAMESPACE --ignore-not-found
kubectl delete deployment $RELEASE-nginx -n $NAMESPACE --ignore-not-found

# Delete Services
echo "Deleting Services..."
kubectl delete svc $RELEASE-grafana -n $NAMESPACE --ignore-not-found
kubectl delete svc $RELEASE-kube-prometheus-stack-prometheus -n $NAMESPACE --ignore-not-found
kubectl delete svc $RELEASE-nginx -n $NAMESPACE --ignore-not-found

# Optionally, delete other resource types if needed:
echo "Deleting Prometheus and AlertManager CRDs..."
kubectl delete prometheus $RELEASE-kube-prometheus-stack -n $NAMESPACE --ignore-not-found
kubectl delete servicemonitor --all -n $NAMESPACE --ignore-not-found
kubectl delete prometheusrule --all -n $NAMESPACE --ignore-not-found
kubectl delete alertmanager $RELEASE-kube-prometheus-stack -n $NAMESPACE --ignore-not-found

# Patch PVC to keep it safe (optional but recommended)
echo "Protecting Grafana PVC from deletion..."
kubectl patch pvc $RELEASE-grafana -n $NAMESPACE -p '{"metadata":{"finalizers":["kubernetes.io/pvc-protection"]}}' || true

echo "Cleanup complete. PVC and dashboards are safe."
