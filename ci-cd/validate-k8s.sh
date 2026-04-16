#!/bin/bash
set -euo pipefail

echo "Validating Kubernetes manifests with kubeval (safe mode)..."

kubeval \
  --strict \
  --ignore-missing-schemas \
  kubernetes/*.yaml

echo "Kubernetes manifests are valid ✅"
