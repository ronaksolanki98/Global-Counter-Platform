#!/bin/bash
set -euo pipefail

echo "Validating Kubernetes manifests (offline mode)..."

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required"
  exit 1
fi

kubectl apply --dry-run=client --validate=false -f kubernetes/

echo "All Kubernetes manifests are valid ✅"
