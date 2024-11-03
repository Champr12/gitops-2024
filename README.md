# Deploying Terraform with GitHub Actions to AWS

## Introduction

This repository demonstrates an automated Infrastructure as Code (IaC) deployment pipeline using Terraform, GitHub Actions, Infracost, TFLint and Open Policy Agent (OPA). The pipeline deploys a EC2 instance with Granfana installed in AWS while showcasing CI/CD for infrastructure deployment.

## Overview

This project uses:

- GitHub Actions for CI/CD.
- Terraform for infrastructure as code.
- Bash script for pre-commit hook.
- TFLint for linting Terraform code.
- Infracost for cost estimation and check.
- OPA for cofiguration policy enforcement.

## Architecture Diagram
![image](https://github.com/user-attachments/assets/e8a4a869-5c0d-492f-9c52-028febf8362b)

## GitHub Actions: Workflows
Terraform (terraform.yml): This workflow initializes Terraform and creates an execution plan to preview infrastructure changes. It runs on feature branch changes and generates a terraform plan output, showing proposed resource modifications without applying them. This step ensures code correctness and previews costs or resource alterations.

TFLint Check (tflint.yml): This workflow will use TFLint to check and identify potential issues, errors, and violations of best practices. It helps maintain code quality, consistency, and reliability in Terraform.

Infracost Check (infracost.yml): This workflow calculates and assesses the cost of infrastructure changes before applying them. Running on pull requests, it uses Infracost to evaluate if new resources will exceed set budget policies, flagging any high-cost additions and promoting cost-efficient practices.

OPA Policy Check (plan_opa.yml): This policy-checking workflow enforces compliance by validating the proposed Terraform resources against predefined Open Policy Agent (OPA) policies. Running alongside the plan step, it ensures infrastructure meets security and operational standards, blocking non-compliant configurations.

Terraform Apply (apply.yml): This workflow is responsible for applying changes after all checks pass. It runs on the main branch, deploying resources to AWS when merged, ensuring only validated, cost-approved, and compliant configurations reach production.

Terraform Destroy (destory.yml): This workflow destroys any existing infrastructure created by the apply.yml workflow.

Terraform Drift Detection (drift.yml): This workflow is ran on a schedule and checks for any infrastructure drift between the actual infrastructure and the Terraform state file (terraform.tfstate).

## GitHub Actions: Actions

The following Actions are used in the above Workflows:

actions/checkout: Checks out the repository code, allowing workflows to access it.
[Documentation](https://github.com/actions/checkout)

actions/cache@v4:This action allows caching dependencies and build outputs to improve workflow execution time. 
[Documentation](https://github.com/actions/cache)

hashicorp/setup-terraform: Sets up the Terraform CLI in GitHub Actions for Terraform commands.
[Documentation](https://github.com/hashicorp/setup-terraform)

infracost/infracost-action: Calculates cost estimates for Terraform changes and checks them against budget policies.
[Documentation](https://github.com/infracost/infracost-action)

opa-action/action: Runs OPA policies to validate Terraform configurations, enforcing compliance.
[Documentation](https://github.com/open-policy-agent/opa-action)

aws-actions/configure-aws-credentials@v4: This action implements the AWS credential resolution chain and exports session environment variables for other Actions to use. 
[Documentation](https://github.com/aws-actions/configure-aws-credentials)

terraform-linters/setup-tflint@v4: Installs a TFLint executable. 
[Documentation](https://github.com/terraform-linters/setup-tflint)

## Contribution Instructions

1. Create a feature branch and make your changes.
2. Run <strong>git config core.hooksPath .github/hooks</strong> to set up the pre-commit hook.
3. Push the branch and open a pull request.
4. Ensure all the three required GitHub Actions checks passes.
5. Once all the required checks passes, apply.yml will be ran to apply the changes and the changes will be monitored.
6. When changes are verified to be safe, the pull request will be merged.

## Merging Strategy

The merging strategy that we will use is <strong>Apply Before Merge</strong>. With the Apply Before Merge strategy, infrastructure changes are first tested and applied in a pull request (PR) environment, where terraform apply is ran manually before merging into the main branch. This way, any issues are caught early in the PR, keeping the main branch stable and error-free. After a successful apply, the PR is merged, with main reflecting only changes that have been successfully validated. The Apply Before Merge approach for Terraform allows testing changes directly in the environment before merging, addressing issues early and reducing "hotfix" PRs due to apply failures.
