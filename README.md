# ☁️ AWS EKS with Terraform

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/09a5dca5-02fb-4760-9c1d-dadb00d5135f" />



Built a production-ready Amazon EKS cluster using Terraform, but with one clear rule:
👉 keep things modular, decoupled, and future-proof.

This setup cleanly separates the Network layer (VPC) from the Application layer (EKS).
The EKS stack doesn’t depend on copy-pasted IDs — it discovers the VPC dynamically using data sources + tags.

Translation:

🧠 smarter architecture \
🧩 better isolation \
🔁 easier reuse across environments

---

## 🏗️ How the Architecture Works

The infra is split into two independent Terraform stacks:

1️⃣ VPC Stack (aws/vpc/dev)

- Provisions the networking layer
- VPC, public & private subnets
- NAT Gateways across 2 AZs for high availability

2️⃣ EKS Stack (aws/eks/dev)

- Provisions IAM roles + EKS cluster
- Automatically finds the VPC using AWS tags
- Zero hardcoded subnet or VPC IDs ❌

Each stack can evolve independently — exactly how real-world infra should work.

## 📁 Directory Structure (Clean & Scalable)
```text
Terraform/
├── modules/               # Reusable Modules (The Blueprints)
│   ├── vpc/               # Networking (VPC, Subnets across 2 AZs, IGW, NAT)
│   ├── iam/               # Permissions (Cluster & Node Roles)
│   └── eks/               # Kubernetes (Cluster Control Plane, Node Groups)
│
└── aws/                   # Live Environments (The Deployments)
    ├── vpc/dev/           # Dev Network Stack
    └── eks/dev/           # Dev Cluster Stack
```

---

## ✅ Prerequisites
Before you begin, ensure you have the following installed:

- Terraform (v1.0+)

- AWS CLI (Configured with aws configure)

- kubectl (To interact with the cluster)



## 🚀 Deployment Guide

Step 1: Deploy the Network (VPC first, always)

EKS needs a home, so we build the network first.

```
cd Terraform/aws/vpc/dev
terraform init
terraform apply --auto-approve

```
This creates:

- A VPC
- Public & private subnets
- Spread across 2 AZs for HA

---

<img width="1152" height="902" alt="image" src="https://github.com/user-attachments/assets/6a5cd553-5334-407c-9290-365f624d652d" /> 




<img width="981" height="371" alt="image" src="https://github.com/user-attachments/assets/d2ab46f6-91cb-4ae2-b985-76564cd72230" />


---

Step 2: Deploy the Cluster (EKS)

Once the network is ready, we deploy the cluster. This stack will automatically look up the VPC tags created in Step 1.

```
cd ../../../aws/eks/dev
terraform init
terraform apply
```

This provisions:

- IAM roles
- EKS control plane
- Worker node group

<img width="948" height="357" alt="image" src="https://github.com/user-attachments/assets/c098dc5a-81d9-4cb1-9d06-be74f8ed8b47" />


---
## 🔌 Connecting to the Cluster
Once the apply is complete, configure your local kubectl to communicate with the new cluster:

```
aws eks update-kubeconfig --region us-east-1 --name my-modular-eks-cluster
```

Verify the connection:

```
kubectl get nodes
```
<img width="1255" height="246" alt="image" src="https://github.com/user-attachments/assets/4147ffdd-9094-4ae4-afd3-efb3791ce89c" />


Not gonna lie…
this kubectl get nodes screenshot deserves respect🔥


<img width="1520" height="495" alt="image" src="https://github.com/user-attachments/assets/e317399b-a6db-4d71-9afc-7520dff0de6d" />


Terraform did its thing and the cluster is officially alive.
Modular infra > demo setups. Always.

---

## 🧠 Final Takeaway

This setup mirrors real production infra:

- Modular
- Decoupled
- Tag-driven
- Easy to scale across dev / staging / prod

Exactly how Terraform + AWS should be used.





