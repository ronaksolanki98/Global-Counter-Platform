#!/bin/bash
set -euo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required"
  exit 1
fi

kubectl apply --dry-run=server -f kubernetes/namespace.yaml
kubectl apply --dry-run=server -f kubernetes/backend-deployment.yaml
kubectl apply --dry-run=server -f kubernetes/backend-service.yaml
kubectl apply --dry-run=server -f kubernetes/frontend-deployment.yaml
kubectl apply --dry-run=server -f kubernetes/frontend-service.yaml
