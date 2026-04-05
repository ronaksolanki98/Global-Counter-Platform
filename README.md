# Serverless Counter Platform

## Project Overview
This repo houses a fully refactored, production-ready serverless web application that counts global views. The frontend is a static client that reports visitor names and polls an AWS Lambda-backed counter service. The backend maintains a DynamoDB counter and exposes a single read-only HTTP endpoint. Everything is wired up with best-practice tooling, infrastructure-as-code, containers, GitHub Actions, and documentation suitable for recruiters or enterprise teams.

## Architecture at a glance
- **Developer → GitHub:** Changes trigger GitHub Actions which run lint/test/build and produce Docker artifacts.
- **CI/CD:** `ci.yml` enforces linting, coverage, Docker builds, and a deployment dry run step that can be expanded for production clusters.
- **Infrastructure:** Terraform modules provision IAM, DynamoDB, and Lambda with secure environment variables defined in `.tfvars` templates.
- **Deployment:** Docker containers host the frontend via Nginx and the backend via a Python runtime. Kubernetes manifests describe the runtime topology (deployment, service, autoscaler).

## Tech stack
- Python 3.12 (Lambda handler)
- AWS Lambda + DynamoDB (serverless counter)
- Static frontend with vanilla JS/CSS served through Nginx
- Docker multi-stage builds for backend/frontend
- Terraform for IaC (modules for IAM, DynamoDB, Lambda)
- GitHub Actions for CI/CD
- Kubernetes manifests for container deployment

## Folder structure
```
/project-root
├── app/
│   ├── backend/        # Python lambda function + requirements
│   └── frontend/       # Static assets, Node tooling
├── infrastructure/
│   └── terraform/      # IaC modules + env templates
├── ci-cd/              # Deployment helper scripts
├── configs/            # Environment config templates
├── docs/               # Architecture + setup documentation
├── docker/             # Dockerfiles for backend/front
├── kubernetes/         # Deployment + service manifests
├── scripts/            # Automation helpers
├── tests/              # Python unit tests
├── .github/workflows/  # CI pipeline definitions
├── README.md           # This overview
├── .gitignore
```

## Setup instructions (local)
1. Install dependencies:
   - Python: `python -m venv .venv && source .venv/bin/activate && pip install -r app/backend/requirements.txt -r app/backend/dev-requirements.txt`
   - Node: `cd app/frontend && npm install`
2. Configure environment variables: `cp configs/.env.example .env` and update values, especially `TABLE_NAME` and `API_URL`.
3. Run backend unit tests: `pytest tests`.
4. Bundle frontend assets: `cd app/frontend && npm run build` (output goes to `dist`).
5. Optional: Run `scripts/validate-stack.sh` to verify Terraform prerequisites.

## How to run locally
- **Backend:** `sam local start-api --template-file infrastructure/terraform/sam-template.yaml` (placeholder, update for your AWS profile) or run tests.
- **Frontend:** Serve `app/frontend/public` via any static server (`npm install -g serve && serve app/frontend/dist`). Configure the `data-api-url` attribute to point to the deployed API Gateway.

## Deployment steps
1. Populate Terraform variables in `infrastructure/terraform/env/dev.tfvars`.
2. `cd infrastructure/terraform && terraform init && terraform plan -var-file=env/dev.tfvars && terraform apply -var-file=env/dev.tfvars` (ensure AWS credentials are set using least-privilege IAM role).
3. Build Docker images: `docker build -t app-backend -f docker/backend/Dockerfile .` and `docker build -t app-frontend -f docker/frontend/Dockerfile app/frontend`.
4. Push images to your container registry.
5. Apply Kubernetes manifests with `kubectl apply -k kubernetes` after setting image references via `kubectl set image` or `kustomize`.

## CI/CD explanation
The `.github/workflows/ci.yml` pipeline enforces:
1. **Lint:** `flake8` for Python and `eslint` for frontend JS.
2. **Test:** `pytest` for backend unit tests.
3. **Build:** Docker builds for frontend/backend images.
4. **Deploy stage (dry-run):** Validates manifests with `kubectl apply --dry-run=server` using secrets for KUBE_CONFIG.

Configure GitHub repo secrets (e.g., `AWS_REGION`, `AWS_ACCOUNT_ID`, `KUBE_CONFIG_DATA`, `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, etc.) to enable deployments.

## Environment variables
See `configs/.env.example` for names/usage. Key values:
- `AWS_REGION`, `TABLE_NAME`, `TRACKING_ID` for the Lambda/Dynamo combo.
- `API_URL` for the frontend to poll.
- `FRONTEND_BASE_URL` if deploying behind a CDN.

## Future improvements
1. Add API Gateway + Cognito authorizer for request throttling and authentication.
2. Introduce CloudFront + S3 for static hosting with custom domain/TLS.
3. Expand frontend UX with state management and integration tests.
4. Add Helm charts, Canary deployments, and more robust observability (CloudWatch dashboards, alerts).
