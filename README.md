Monitoring Automation for K3s
Project Overview
This project automates the deployment and configuration of a monitoring stack on K3s using Helm, Prometheus, and Grafana. The stack provides monitoring of Kubernetes resources such as CPU, memory usage, and pod status through Grafana dashboards. It also sets up alerting rules for resource usage and pod health. The project is fully automated with Bash scripts, and it includes a CI/CD pipeline using GitHub Actions for easy deployment and uninstallation.

Key Features
Automated Deployment: Use Helm and Bash scripts for easy deployment and uninstallation of Prometheus, Grafana, and monitoring configurations.

Prometheus & Grafana Integration: Configure Prometheus to scrape metrics from the Kubernetes cluster and Grafana to visualize them in custom dashboards.

Alerting Rules: Automatically set up Prometheus alert rules for high CPU and memory usage, pod restarts, and error terminations.

CI/CD Pipeline: Automate deployment and uninstallation using GitHub Actions.

Project Structure
plaintext
Copy
Edit
monitoring-k3s-automation/
│
├── charts/                     # Custom Helm charts (if any)
│
├── configs/                    # Configuration files for Prometheus, Grafana, and alerts
│   ├── values.yaml             # Helm values for Prometheus and Grafana setup
│   ├── prometheus-rules.yaml  # Prometheus alert rules configuration
│   └── grafana-dashboard.json # Grafana dashboard JSON export
│
├── deployments/                # Kubernetes resource files
│   ├── nginx-deployment.yaml  # Sample NGINX deployment for monitoring
│   └── grafana-service.yaml   # Expose Grafana via a NodePort service
│
├── scripts/                    # Automation scripts
│   ├── deploy-monitoring.sh    # Automated script to deploy the monitoring stack
│   └── uninstall-monitoring.sh # Automated script to uninstall the monitoring stack
│
├── .github/                    # GitHub Actions CI/CD pipeline
│   └── workflows/
│       └── ci-cd.yml           # CI/CD pipeline YAML for automated deployment
│
├── README.md                   # Project documentation (this file)
└── LICENSE                     # License file (if applicable)
Prerequisites
Before using the automation scripts and Helm charts, make sure you have the following tools installed:

K3s or Minikube for a Kubernetes cluster

K3s Installation Guide

Minikube Installation Guide

Helm for managing Kubernetes applications

Helm Installation Guide

Kubectl for interacting with the Kubernetes cluster

Kubectl Installation Guide

GitHub account to run the CI/CD pipeline (for automated deployment/uninstallation)

Setup Instructions
1. Spin Up a Local K3s/Minikube Cluster
For K3s:

bash
Copy
Edit
curl -sfL https://get.k3s.io | sh -
sudo systemctl enable k3s
sudo systemctl start k3s
For Minikube:

bash
Copy
Edit
minikube start
2. Add Helm Repositories
Add the necessary Helm repositories for Prometheus and Grafana:

bash
Copy
Edit
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
3. Customize values.yaml
In the configs/ directory, modify the values.yaml file for both Prometheus and Grafana to suit your needs (e.g., enabling persistent storage, setting up alert rules, etc.).

4. Automated Deployment
Run the deploy-monitoring.sh script to automatically install Prometheus and Grafana via Helm, and deploy a simple Kubernetes application (NGINX in this case):

bash
Copy
Edit
bash scripts/deploy-monitoring.sh
5. Expose Grafana and Prometheus
Grafana and Prometheus will be exposed via NodePort at the following ports:

Prometheus: 30900

Grafana: 30901

NGINX (example application): 30903

You can access the Grafana dashboard at http://<NODE_IP>:30901 and Prometheus at http://<NODE_IP>:30900.

6. Add Custom Grafana Dashboards
Create custom Grafana dashboards and preload them via a ConfigMap. The example JSON dashboard is located in the configs/grafana-dashboard.json file. This dashboard includes:

CPU Usage

Memory Usage

Pod Status

Apply the ConfigMap to load the dashboard into Grafana:

bash
Copy
Edit
kubectl apply -f configs/grafana-dashboard-configmap.yaml
7. Automate Alerting Rules
Prometheus alerting rules for High CPU, High Memory, Pod Restarts, and Pod Termination Errors are configured in the configs/prometheus-rules.yaml file.

Apply the alert rules:

bash
Copy
Edit
kubectl apply -f configs/prometheus-rules.yaml
8. Export Grafana Dashboards as JSON
Export your Grafana dashboard as a JSON file:

bash
Copy
Edit
curl -X GET "http://<GRAFANA_HOST>:30901/api/dashboards/uid/<DASHBOARD_UID>" -H "Authorization: Bearer <API_KEY>" -o exported_dashboard.json
CI/CD Pipeline with GitHub Actions
This repository includes a CI/CD pipeline set up with GitHub Actions for automated deployment and uninstallation.

GitHub Actions Workflow
The CI/CD pipeline is defined in .github/workflows/ci-cd.yml. This file automates the following:

Deploying the Monitoring Stack: Triggered on push to the main branch, it deploys Prometheus, Grafana, and the sample NGINX app to your cluster.

Uninstalling the Monitoring Stack: A job to remove Prometheus, Grafana, and all associated resources.

Uninstallation
If you want to remove the entire monitoring stack from your K3s cluster, you can run the uninstall-monitoring.sh script:

bash
Copy
Edit
bash scripts/uninstall-monitoring.sh
This script will:

Uninstall Prometheus and Grafana via Helm.

Delete any associated Kubernetes resources
