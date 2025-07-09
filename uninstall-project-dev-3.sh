#!/bin/bash
set -e

NAMESPACE="project-monitoring"
RELEASE="project-dev-3"

echo "Uninstalling Helm release..."
helm uninstall $RELEASE -n $NAMESPACE

echo "Deleting namespace..."
kubectl delete namespace $NAMESPACE

echo "Cleanup done."
