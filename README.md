# terraform-eks
Absolutely! Here's the entire README compiled into a **single, clean, and well-structured README.md** file you can copy and save directly:

---

````markdown
# Production-Grade Private EKS Cluster with Terraform

This repository contains Terraform code to provision a **secure, scalable, private, production-grade AWS EKS cluster** with:

- Modular and reusable Terraform code supporting multiple environments (dev, SIT, prod)
- Three-tier VPC architecture: Public, Private, and Isolated subnets
- Private EKS control plane and worker nodes deployed inside private subnets
- Dynamic autoscaling of worker nodes using **Karpenter**
- AWS Load Balancer Controller (ALB Ingress Controller) for ingress management
- Optional Amazon EFS integration for persistent storage
- Amazon Linux 2023 AMI support for worker nodes (future-proof)
- Best practices for security, scalability, and maintainability

---

## Architecture Overview

```plaintext
                ┌─────────────┐
                │   Internet  │
                └──────┬──────┘
                       │
               ┌───────▼───────┐
               │  Public Subnets│  <-- NAT Gateways, ALBs, Bastion hosts
               └───────┬───────┘
                       │
         ┌─────────────▼─────────────┐
         │      Private Subnets      │  <-- EKS Worker Nodes & Cluster Endpoints
         └─────────────┬─────────────┘
                       │
               ┌───────▼───────┐
               │ Isolated Subnets │  <-- Databases, sensitive workloads (optional)
               └───────────────┘
````

---

## Repository Structure

```
terraform-eks/
├── modules/                   # Reusable Terraform modules
│   ├── vpc/                  # VPC module with 3-tier subnet architecture
│   ├── eks/                  # EKS cluster module with managed node groups and Karpenter
│   └── karpenter/            # Karpenter provisioner module
├── environments/             # Environment-specific variables
│   ├── dev/
│   │   └── terraform.tfvars
│   └── prod/
│       └── terraform.tfvars
├── main.tf                   # Root Terraform configuration
├── variables.tf              # Global variables definition
├── outputs.tf                # Outputs from root module
├── provider.tf               # AWS provider configuration
└── locals.tf                 # Local variables and naming conventions
```

---

## Prerequisites

* **Terraform v1.5+** installed and configured
* **AWS CLI** installed and configured with credentials having sufficient permissions (EKS, VPC, IAM, EC2, ELB, etc.)
* **kubectl** installed for interacting with the Kubernetes cluster
* Optional: **Python 3.13+** for helper scripts (e.g., zip file generation)

---

## Step-by-Step Deployment Guide

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/terraform-eks.git
cd terraform-eks
```

---

### 2. Configure AWS CLI

Make sure your AWS CLI is configured with the right account and region:

```bash
aws configure
```

Provide AWS Access Key ID, Secret Key, default region (e.g., `us-east-1`), and output format (`json` recommended).

---

### 3. Choose Environment & Set Variables

Terraform variables are environment-specific and stored in:

```
environments/dev/terraform.tfvars
environments/prod/terraform.tfvars
```

Edit the respective `.tfvars` file to set:

* Cluster name
* Region
* Node instance types and scaling parameters
* Additional tags or settings as needed

---

### 4. Initialize Terraform

From the root directory:

```bash
terraform init
```

This downloads providers and initializes modules.

---

### 5. Validate Terraform Configuration

Always a good idea before planning:

```bash
terraform validate
```

---

### 6. Generate an Execution Plan

Specify the environment variables file for your environment:

```bash
terraform plan -var-file=environments/dev/terraform.tfvars
```

Review the output carefully to verify what resources will be created or changed.

---

### 7. Apply Terraform Configuration

Apply to provision infrastructure:

```bash
terraform apply -var-file=environments/dev/terraform.tfvars
```

Confirm with `yes` when prompted.

---

### 8. Configure kubectl to Access the Cluster

Once the cluster is up, configure your kubeconfig:

```bash
aws eks --region <region> update-kubeconfig --name <cluster_name>
```

Example:

```bash
aws eks --region us-east-1 update-kubeconfig --name dev-cluster
```

Verify access:

```bash
kubectl get nodes
```

You should see your worker nodes in the `Ready` state.

---

### 9. Verify Karpenter & ALB Controller

* **Karpenter** provisions worker nodes dynamically based on workload demands.

Check Karpenter pods:

```bash
kubectl get pods -n karpenter
```

* **AWS Load Balancer Controller** manages ingress resources.

Check ALB controller pods:

```bash
kubectl get pods -n kube-system | findstr alb
```

---

## Cleaning Up

To destroy all resources and avoid charges:

```bash
terraform destroy -var-file=environments/dev/terraform.tfvars
```

---

## Important Notes

* **vpc\_id is NOT passed to the EKS module**, as the EKS resource only requires subnet IDs.
* This design supports **multi-environment deployments** by using variable files.
* **Karpenter enables autoscaling** beyond fixed managed node groups for cost efficiency.
* The **Load Balancer Controller** automates ALB lifecycle for Kubernetes ingress.
* Subnets are designed to isolate workloads and secure sensitive data.
* **Amazon Linux 2023 AMI** support ensures compatibility with the latest security and features.

---

## Troubleshooting

| Problem                                             | Solution                                                             |
| --------------------------------------------------- | -------------------------------------------------------------------- |
| Terraform error: `Unexpected attribute vpc_id`      | Remove `vpc_id` from the `eks` module call in `main.tf`              |
| `kubectl` cannot connect to cluster                 | Run `aws eks update-kubeconfig` with correct region and cluster name |
| Pods in `karpenter` or `alb` namespaces not running | Check IAM permissions, logs, and pod events for errors               |
| Terraform plan/apply fails                          | Ensure Terraform version is >= 1.5, and AWS CLI is configured        |

---

## Contributing

Contributions, issues, and feature requests are welcome!

* Fork the repository
* Create a feature branch (`git checkout -b feature-branch`)
* Commit your changes (`git commit -m 'Add feature'`)
* Push to the branch (`git push origin feature-branch`)
* Open a Pull Request

---



## References

* [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
* [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Karpenter Autoscaler](https://karpenter.sh/)
* [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/)
```
