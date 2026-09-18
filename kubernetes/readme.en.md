# ☸️ Kubernetes Infrastructure & Production Lab

This project demonstrates a practical Kubernetes environment built with a local Kubernetes cluster. The lab covers container orchestration, networking, storage, configuration management, security, scaling, workload management, Helm and troubleshooting.

The project also includes a production-style application deployed using Kubernetes manifests and later converted into a reusable Helm chart.

---

## 📌 Project Overview

The Kubernetes lab was built to gain hands-on experience with Kubernetes administration and application deployment.

The environment includes:

* Kubernetes cluster management
* Pods, Deployments and ReplicaSets
* Services and internal networking
* ConfigMaps and Secrets
* Persistent Volumes and Persistent Volume Claims
* Liveness and readiness probes
* Resource requests and limits
* Horizontal Pod Autoscaling
* Ingress and HTTP routing
* NetworkPolicies
* RBAC and ServiceAccounts
* StatefulSets and headless Services
* Jobs and CronJobs
* DaemonSets
* Helm charts and releases
* Production-style application deployment
* Troubleshooting and failure scenarios

---

## 🏗️ Architecture

### Architecture Diagram

The lab runs on a local Kubernetes cluster with workload management, internal services, persistent storage, networking and Helm-managed applications.

![Kubernetes Architecture](01-k8s-diagram.jpg)

---

## 1. ⚙️ Kubernetes Cluster

The Kubernetes environment is based on a local cluster with a control-plane node and the standard Kubernetes control-plane components.

### Configuration

| Resource            | Configuration           |
| ------------------- | ----------------------- |
| Cluster             | `desktop-control-plane` |
| Kubernetes Version  | `v1.36.1`               |
| Container Network   | Kind networking         |
| DNS                 | CoreDNS                 |
| Metrics             | Metrics Server          |
| Storage Provisioner | Local Path Provisioner  |

### 📸 Screenshot 02 — Cluster

![Kubernetes Cluster](02-cluster.png)

---

## 2. 📦 Workloads

The lab uses multiple Kubernetes workload types including Deployments, Pods, ReplicaSets and StatefulSets.

Production workloads use multiple replicas to provide application availability.

### 📸 Screenshot 03 — Workloads

![Kubernetes Workloads](03-workloads.png)

---

## 3. 🌐 Services & Networking

Kubernetes Services are used to expose applications and provide stable network endpoints.

The lab includes:

* ClusterIP Services
* NodePort Service
* LoadBalancer Service
* Headless Service

### 📸 Screenshot 04 — Services

![Kubernetes Services](04-services.png)

---

## 4. ⚙️ ConfigMaps & Secrets

Application configuration and sensitive configuration values are separated from container images using Kubernetes ConfigMaps and Secrets.

The production application includes both resources.

### 📸 Screenshot 05 — ConfigMaps & Secrets

![ConfigMaps and Secrets](05-config-secrets.png)

---

## 5. 💾 Persistent Storage

Persistent storage is implemented using PersistentVolumes and PersistentVolumeClaims.

The production application uses a PVC backed by the local storage provisioner.

### Configuration

| Resource      | Configuration        |
| ------------- | -------------------- |
| PVC           | `production-storage` |
| Size          | `1Gi`                |
| Access Mode   | `RWO`                |
| Storage Class | `standard`           |
| Status        | `Bound`              |

### 📸 Screenshot 06 — Storage

![Persistent Storage](06-storage.png)

### 📸 Screenshot 07 — Persistence Test

The persistence workflow was tested by recreating the application Pod and verifying that the persistent storage remained available.

![Persistence Test](07-persistence.png)

---

## 6. ❤️ Health Checks

Liveness and readiness probes are used to monitor application health.

* **Liveness probe** — detects whether a container should be restarted.
* **Readiness probe** — determines whether a Pod is ready to receive traffic.

### 📸 Screenshot 08 — Probes

![Liveness and Readiness Probes](08-probes.png)

---

## 7. 📈 Resources & Autoscaling

Resource requests and limits are configured for workloads.

Horizontal Pod Autoscaling is also implemented.

### Configuration

| Resource                 | Min Replicas | Max Replicas |  Target |
| ------------------------ | -----------: | -----------: | ------: |
| `production-app`         |            2 |            5 | 50% CPU |
| `production-backend`     |            2 |            5 | 50% CPU |
| `nginx-test-nginx-chart` |            2 |            5 | 50% CPU |

### 📸 Screenshot 09 — Resources & HPA

![Resources and HPA](09-resources-hpa.png)

---

## 8. 🌐 Ingress & Network Security

Ingress is used to route external HTTP traffic to Kubernetes Services.

NetworkPolicies are used to control Pod-to-Pod communication.

The production application contains a NetworkPolicy allowing the required application traffic from the production client.

### 📸 Screenshot 10 — Ingress & NetworkPolicy

![Ingress and NetworkPolicy](10-ingress-network.png)

---

## 9. 🔐 RBAC & ServiceAccounts

Kubernetes RBAC is used to control access to cluster resources.

ServiceAccounts are used to provide workloads with controlled identities.

### 📸 Screenshot 11 — RBAC

![RBAC and ServiceAccount](11-rbac.png)

---

## 10. 🖥️ DaemonSet

A DaemonSet is used to run a Pod on the required Kubernetes node.

The lab includes a `node-agent` DaemonSet.

### 📸 Screenshot 12 — DaemonSet

![DaemonSet](12-daemonset.png)

---

## 11. 🗄️ StatefulSet & Headless Service

A StatefulSet is used for workloads that require stable Pod identities.

The lab includes:

* `nginx-stateful`
* Two StatefulSet replicas
* Headless Service
* Stable Pod naming

### 📸 Screenshot 13 — StatefulSet

![StatefulSet and Headless Service](13-statefulset.png)

---

## 12. ⏱️ Jobs & CronJobs

Kubernetes Jobs and CronJobs were used to demonstrate one-time and scheduled workloads.

### 📸 Screenshot 14 — Jobs

![Jobs and CronJobs](14-jobs.png)

---

## 13. ⛵ Helm

Helm is used to package and deploy Kubernetes applications.

The lab contains two Helm charts:

```text
nginx-chart/
production-app/
```

The charts use:

* `Chart.yaml`
* `values.yaml`
* Helm templates
* Services
* Deployments
* HPA
* Ingress
* ConfigMaps
* Secrets
* PVC

### 📸 Screenshot 15 — Helm Chart

![Helm Chart Structure](15-helm-chart.png)

---

## 14. 🚀 Helm Releases

The current cluster contains two deployed Helm releases.

| Release          | Chart                  | Revision | Status   |
| ---------------- | ---------------------- | -------: | -------- |
| `nginx-test`     | `nginx-chart-0.1.0`    |        7 | deployed |
| `production-app` | `production-app-0.1.0` |        4 | deployed |

### 📸 Screenshot 16 — Helm Releases

![Helm Releases](16-helm-releases.png)

---

## 15. 🏭 Production Application

A production-style application was deployed using Kubernetes resources and later converted into a Helm chart.

The application includes:

* Deployment
* Service
* ConfigMap
* Secret
* PersistentVolumeClaim
* Ingress
* NetworkPolicy
* HPA

The production deployment runs with two replicas.

### 📸 Screenshot 17 — Production Stack

![Production Kubernetes Stack](17-production-stack.png)

---

## 16. 🧪 Production Testing

The production application was tested through the configured Kubernetes networking path.

The test verifies that the application is reachable and responding correctly.

### 📸 Screenshot 18 — Production Test

![Production Application Test](18-production-test.png)

---

## 17. ⛑️ Troubleshooting

The lab includes intentionally broken Kubernetes resources to practice diagnosing common failures.

### Troubleshooting Scenarios

| Scenario                     | Manifest                |
| ---------------------------- | ----------------------- |
| Broken Pod                   | `broken-pod.yaml`       |
| Crashing Pod                 | `crash-pod.yaml`        |
| Pending Pod                  | `pending-pod.yaml`      |
| Broken Service               | `broken-service.yaml`   |
| Configuration Failure        | `config-broken.yaml`    |
| CPU Resource Problem         | `cpu-broken.yaml`       |
| OOM Condition                | `oom-broken.yaml`       |
| Readiness Failure            | `readiness-broken.yaml` |
| Secret Configuration Failure | `secret-broken.yaml`    |

### 📸 Screenshot 19 — Troubleshooting

![Kubernetes Troubleshooting](19-troubleshooting.png)

### 📸 Screenshot 20 — Network Troubleshooting

![Network Troubleshooting](20-troubleshooting-network.png)

---

## 🛠️ Technologies

* Kubernetes
* kubectl
* Kind
* Docker
* Helm
* YAML
* Nginx
* Kubernetes Ingress
* NetworkPolicy
* RBAC
* Persistent Volumes
* Horizontal Pod Autoscaling

---

## 📚 Skills Demonstrated

* Kubernetes cluster administration
* Container orchestration
* Deployment and ReplicaSet management
* Service networking
* Ingress configuration
* Configuration and secret management
* Persistent storage
* Health monitoring
* Resource management
* Horizontal Pod Autoscaling
* Network security
* RBAC
* Stateful workloads
* Scheduled workloads
* DaemonSets
* Helm-based deployments
* Kubernetes troubleshooting
* Production-style application deployment

---

## 🚀 Next Steps

* Advanced Kubernetes networking
* Advanced Helm templating
* CI/CD integration with Kubernetes
* Container registry integration
* GitOps workflows
* Cloud Kubernetes services such as AKS, EKS and GKE

---

## 📌 Project Status

**Status:** Completed ✅

The lab successfully demonstrates practical Kubernetes administration, application deployment, networking, storage, security, scaling, Helm and troubleshooting in a local Kubernetes environment.
