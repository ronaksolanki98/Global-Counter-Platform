#!/bin/bash
set -euo pipefail

echo "Validating Kubernetes manifests (client-side)..."

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required"
  exit 1
fi

# Client-side validation (NO cluster required)
kubectl apply --dry-run=client -f kubernetes/namespace.yaml
kubectl apply --dry-run=client -f kubernetes/backend-deployment.yaml
kubectl apply --dry-run=client -f kubernetes/backend-service.yaml
kubectl apply --dry-run=client -f kubernetes/frontend-deployment.yaml
kubectl apply --dry-run=client -f kubernetes/frontend-service.yaml

echo "Kubernetes manifests validation passed ✅"
