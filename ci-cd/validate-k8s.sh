#!/bin/bash
set -euo pipefail

echo "Validating Kubernetes manifests with kubeval..."

kubeval kubernetes/*.yaml

echo "Kubernetes manifests are valid ✅"
