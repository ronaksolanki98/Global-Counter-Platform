#!/bin/bash
set -euo pipefail

ENV=${1:-dev}
TF_DIR="infrastructure/terraform"
TF_VARS="${TF_DIR}/env/${ENV}.tfvars"

if [ ! -f "$TF_VARS" ]; then
  echo "TF var file $TF_VARS not found"
  exit 1
fi

cd "$TF_DIR"
terraform init >/dev/null
terraform plan -var-file="$TF_VARS"
terraform apply -var-file="$TF_VARS"
