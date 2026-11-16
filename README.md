# Infrastructure as Code with Terraform and Docker

[![Infrastructure CI/CD Pipeline](https://github.com/nerminekabadou/TP_DevOps_IaC/actions/workflows/main.yml/badge.svg)](https://github.com/nerminekabadou/TP_DevOps_IaC/actions/workflows/main.yml)

A DevOps lab: a two-tier stack (PostgreSQL + an Nginx web app) described entirely in Terraform with the Docker provider, then deployed, tested and destroyed automatically by GitHub Actions on every push.

## What Terraform creates

| Resource | Details |
|----------|---------|
| `tp-db-postgres` | `postgres:16-alpine`, port 5432. Database, user and password come from variables |
| `tp-app-web` | Image built from [`Dockerfile_app`](Dockerfile_app) (Alpine + Nginx), served on `localhost:8080`. Starts after the database (`depends_on`) |

Outputs: `db_container_name`, `app_access_url`.

## CI/CD pipeline

[`.github/workflows/main.yml`](.github/workflows/main.yml):

```
fmt -check → init → validate → plan → apply → smoke test (curl the app) → destroy
```

The database password is generated for each run. The stack lives only on the runner and is always destroyed at the end, even if a step fails.

## Run locally

Requirements: Docker and Terraform ≥ 1.5.

```bash
export TF_VAR_db_password="choose-a-password"   # PowerShell: $env:TF_VAR_db_password="..."
terraform init
terraform apply
curl http://localhost:8080                       # "Application Deployed via Terraform IaC!"
terraform destroy
```

Variables (`variables.tf`): `db_name` (default `devops_db`), `db_user` (default `devops_user`), `db_password` (required, sensitive), `app_port_external` (default `8080`).

## Files

```
main.tf          Docker provider, images and containers
variables.tf     inputs
outputs.tf       container name and app URL
Dockerfile_app   Nginx web app image
```
