# Setup & Provisioning Guide

## Local developer flow
1. `git clone` this repository and open it.
2. Create a Python virtual environment and install backend dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r app/backend/requirements.txt -r app/backend/dev-requirements.txt
   ```
3. Boot the frontend toolchain:
   ```bash
   cd app/frontend
   npm install
   npm run lint
   npm run build
   ```
4. Create a `.env` file using the template under `configs/.env.example`. Update `TABLE_NAME`, `TRACKING_ID`, and `API_URL` to point to your deployment.
5. Start the backend locally (if you want to test with an HTTP server) via `python -m app.backend.handler` or `sam local start-api` once infrastructure is provisioned.

## Terraform environment layout
- `infrastructure/terraform/main.tf` wires modules for IAM, DynamoDB, and Lambda.
- Environment variable files live under `infrastructure/terraform/env/`. Copy `env/dev.tfvars` or create a new one for staging/prod.

## Terraform bootstrap
```bash
cd infrastructure/terraform
terraform init
terraform plan -var-file=env/dev.tfvars
terraform apply -var-file=env/dev.tfvars
```
Ensure your AWS credentials (with least privilege IAM user) are available in the environment before running.

## Docker + Kubernetes
1. Build Docker images (tag names are placeholders):
   ```bash
   docker build -t serverless-counter-backend -f docker/backend/Dockerfile .
   docker build -t serverless-counter-frontend -f docker/frontend/Dockerfile app/frontend
   ```
2. Push to your registry and note the image names.
3. Update `kubernetes/*.yaml` with the real image names and run `kubectl apply -f kubernetes/` or use `kustomize`.
4. Verify services (backend api + frontend) are reachable via `kubectl get svc` and inspect pods with `kubectl get pods`.

## CI/CD notes
- GitHub Actions require repository secrets for Docker registry credentials, AWS credentials, and the kubeconfig to run the deployment check.
- The workflow first installs Python & Node, runs lint/test/build, then builds Docker images and runs a `kubectl apply --dry-run=server` on the manifests.
