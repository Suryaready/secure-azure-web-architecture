# Secure Two-Tier Azure Web Architecture

A hands-on implementation of a highly secure, observable, and isolated two-tier web architecture in Microsoft Azure, designed in alignment with AZ-104 enterprise best practices.

## 🏗️ Architecture Overview

This project demonstrates network isolation by separating public-facing ingress services from private backend compute infrastructure.

* **Virtual Network (VNet):** `vnet-prod-01` scoped at `10.0.0.0/16`.
* **Public Tier:** `AppGatewaySubnet` (`10.0.1.0/24`) housing an Azure Application Gateway (v2) acting as a Layer 7 load balancer and reverse proxy.
* **Private Tier:** `BackendSubnet` (`10.0.2.0/24`) completely isolated with no assigned Public IPs. Contains an Ubuntu Server VM running an automated Nginx deployment.

### Infrastructure Topology Map
![Azure Resource Visualizer](./images/visualizer-map.jpg)

---

## 🛠️ Key Implementation Details

### Day 1-2: Networking & Security Perimeter
* Configured multi-tier subnets ensuring strict separation of controls.
* Provisioned a standard Storage Account (`stwebalert01`) secured behind network firewalls, allowing access only to specific whitelisted management IPs.

### Day 3: Automated Compute Deployment
* Deployed `vm-prod-web-01` without a public IP interface to completely negate direct internet-borne brute-force vectors.
* Leveraged **Custom Script Extensions for Linux** to dynamically inject and execute shell scripts (`install_nginx.sh`) at boot, achieving zero-touch automation for the Nginx web server.

### Day 4: Centralized Observability & Telemetry
* Created a **Log Analytics Workspace** (`law-prod-monitoring`) to act as a central log repository.
* Deployed a **Data Collection Rule (DCR)** to distribute the modern Azure Monitor Agent (AMA) to the VM, successfully streaming Linux system warning metrics (`Syslog`).
* Configured a **Metric Alert Rule** to monitor threshold breaches (>80% CPU usage) hooked to an active email **Action Group** for automated operations alerting.

### Day 5: Enterprise Identity & RBAC Validation
* Implemented Least Privilege Administrative models within Microsoft Entra ID by creating a test identity (`labreader`).
* Scoped a strict `Reader` role at the Resource Group layer (`RG-1`).
* Validated control plane isolation via private browsing sessions; verified that unauthorized resource configurations correctly resulted in `AuthorizationFailed` faults.

### Day 6: Edge Traffic Routing
* Deallocated a dedicated `AppGatewaySubnet` and configured an **Azure Application Gateway** with public-facing frontend bindings.
* Mapped Backend Pools, Listeners, and Routing Rules on Port 80 to bridge public user requests securely down to the isolated backend subnet.

---

## 📊 Verification & Validation Proof

### 1. External Web Access Success
Traffic successfully processes through the public Application Gateway frontend IP and routes down to the hidden backend server:
![Live Web Page](./images/web-page-success.jpg)

### 2. RBAC Security Policy Enforcement
The Azure Control Plane blocking unauthorized resource modification attempts by the limited reader identity:
![RBAC Denied Rule](./images/rbac-denied.jpg)

---

## 🧹 Cost Optimization & Takedown
To adhere to cloud cost-optimization strategies, all infrastructure assets including the Application Gateway computing nodes and operational Virtual Machines were cleanly deallocated/destroyed immediately post-validation to limit idle run-time billing.