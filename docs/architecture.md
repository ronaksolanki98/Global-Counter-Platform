# Architecture

## High-level flow
1. Developer commits to **GitHub**. The repository is structured into clearly separated concerns: `app/`, `infrastructure/`, `docs/`, `kubernetes/`, etc.
2. **GitHub Actions** run linting, testing, and Docker builds defined in `.github/workflows/ci.yml`. Any failure stops the pipeline early.
3. Built artifacts (Docker images) are pushed to the configured container registry (placeholder step in the sample pipeline).
4. **Terraform** (under `infrastructure/terraform`) provisions AWS resources: an IAM user/role with least privilege, a DynamoDB table for the counter, and a Lambda function wired with environment variables.
5. **Deployment:** Kubernetes manifests in `kubernetes/` describe backend and frontend Deployments/Services. Actual image tags are set via CI or `kubectl set image` before applying the manifests.
6. The frontend polls the backend API (via `data-api-url`), and the backend safely increments the DynamoDB counter and returns JSON.
7. Logs are emitted via Lambda, and infrastructure ensures idempotency by using `UpdateExpression` with `if_not_exists`.

## Component responsibilities
- **Frontend (`app/frontend`):** Static assets serve UI, use `app/frontend/scripts/build.js` to copy assets into `dist`, and rely on environment configuration for the API endpoint.
- **Backend (`app/backend`):** Python Lambda using `boto3` to increment DynamoDB counters. `handler.py` contains a single endpoint to keep the service minimal and traceable.
- **Infrastructure (`infrastructure/terraform`):** Modular Terraform (IAM, DynamoDB, Lambda) that can be reused across environments. Each module exposes inputs/outputs to stay organized.
- **Containerization (`docker/`):** Multi-stage Dockerfiles produce optimized backend and Nginx-based frontend images ready for Kubernetes deployments.
- **CI/CD (`.github/workflows/ci.yml` + `ci-cd/`):** Orchestrates linting, testing, Docker builds, and deployment validations with checkpointing and secret handling.

## Scalability & reliability considerations
- **Idempotency** is enforced via DynamoDB's `if_not_exists` update expression and the single HTTP GET operation.
- **Modular IaC** allows reusing IAM/DynamoDB configurations across staging/production.
- **Docker multi-stage builds** reduce image surface area.
- **Kubernetes manifests** include resource limits and replicas for horizontal scaling, and readiness probes can be added easily from the template.
- **CI/CD** is fail-fast: linting stops early, and explicit deployment dry runs guard against invalid manifests.
