#!/bin/bash
set -euo pipefail

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform is required"
  exit 1
fi

terraform -chdir=infrastructure/terraform init >/dev/null
terraform -chdir=infrastructure/terraform validate
