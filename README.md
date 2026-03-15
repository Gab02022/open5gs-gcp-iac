# 🚀 5G Cloud-Native Lab: Open5GS & UERANSIM on GCP with GitOps

> 🌐 **Read this in other languages:** [🇪🇸 Español](README-es.md)

This repository contains the complete Infrastructure as Code (IaC) and GitOps configuration to deploy a fully functional 5G Core network (Open5GS) and a simulated Radio Access Network with User Equipment (UERANSIM) on Google Kubernetes Engine (GKE).

## 🏗️ Architecture Overview
* **Cloud Provider:** Google Cloud Platform (GCP)
* **Infrastructure as Code (IaC):** Terraform (VPC, Subnets, GKE Cluster, Node Pools)
* **GitOps Controller:** ArgoCD (deployed via Terraform/Helm)
* **5G Core:** Open5GS (managed by ArgoCD using custom Helm charts)
* **5G RAN & UE:** UERANSIM (managed by ArgoCD using custom Helm charts)
* **Automation:** GitHub Actions (CI/CD pipeline) with Workload Identity Federation (OIDC)


## ✨ Key Features
* **Zero-Touch Provisioning:** The entire infrastructure and application stack can be deployed from scratch using GitHub Actions.
* **Auto-Populating Database:** Includes a custom Kubernetes Job that automatically injects subscriber data (IMSIs and cryptographic keys) into MongoDB upon deployment, eliminating manual database tunneling.
* **Self-Healing:** ArgoCD constantly monitors the repository and the cluster, ensuring the deployed state matches the declarative configuration.
* **Cost Optimization:** Includes a teardown pipeline to completely destroy the GCP environment and prevent unwanted billing.

## 📂 Repository Structure (Infrastructure)
This repository cntains purely the IaC and GitOps bootstrapping. The application manifests are hosted in a separate repository to maintain a clean separation of concerns.

* `/01-bootstrap`: Terraform configurations for the initial GCP environment setup (GCS State Bucket, Service Account, Workload Identity Federation).
* `/02-infra`: Terraform configurations for the base GCP infrastructure (VPC, Subnets, GKE Cluster).
* `/03-argocd`: Terraform configurations to install ArgoCD and configure the GitOps synchronization.
* `/.github/workflows`: GitHub Actions pipelines for automated CI/CD creation and destruction.
* `Makefile`: Local automation script for rapid deployment (`make up` / `make down`).

🔗 **Application Repository:** The Helm charts and Kubernetes manifests for Open5GS, UERANSIM, and the Python initialization Job are managed by ArgoCD from this repository: [Gab02022/open5gs-k8s-gcp-test](https://github.com/Gab02022/open5gs-k8s-gcp-test).

## 🛠️ Phase 0: Bootstrap
Before GitHub Actions can automate the infrastructure, it needs a way to authenticate to GCP (Workload Identity Federation) and a place to store the Terraform state (GCS Bucket). Because GitHub Actions cannot create the very credentials it needs to log in, this initial phase must be applied locally.

From your local terminal or Google Cloud Shell, authenticate with your admin account and run:
```bash
cd 01-bootstrap
terraform init
terraform apply -auto-approve

## 🚀 How to Deploy

### Option 1: Fully Automated via GitHub Actions (Recommended)
1. Go to the **Actions** tab in this repository.
2. Select the `Deploy Infrastructure` workflow.
3. Click **Run workflow**. 
4. Sit back and watch Terraform and ArgoCD build the 5G network.

### Option 2: Local Deployment
Ensure you have `gcloud`, `terraform`, and `kubectl` installed and authenticated.
```bash
# Deploy the complete environment
make up

# Destroy the complete environment
make down
```
## 🤝 Acknowledgments & Credits

This project was inspired by and builds upon the structural and automation concepts from [samuelrojasm/blueprint-aws-tf-bootstrap](https://github.com/samuelrojasm/blueprint-aws-tf-bootstrap). Huge thanks to Samuel Rojas for the foundational work that helped shape the IaC and GitOps approach of this lab.
