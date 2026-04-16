#!/bin/bash
set -euo pipefail

echo "Validating Kubernetes manifests (true offline mode)..."

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required"
  exit 1
fi

# Use CREATE instead of APPLY (important)
kubectl create --dry-run=client -f kubernetes/namespace.yaml -o yaml >/dev/null
kubectl create --dry-run=client -f kubernetes/backend-deployment.yaml -o yaml >/dev/null
kubectl create --dry-run=client -f kubernetes/backend-service.yaml -o yaml >/dev/null
kubectl create --dry-run=client -f kubernetes/frontend-deployment.yaml -o yaml >/dev/null
kubectl create --dry-run=client -f kubernetes/frontend-service.yaml -o yaml >/dev/null

echo "Kubernetes manifests validation passed ✅"
