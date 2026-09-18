# ☸️ Kubernetes Infrastruktur & Production Lab

Dieses Projekt zeigt eine praktische Kubernetes-Umgebung, die auf einem lokalen Kubernetes-Cluster aufgebaut wurde. Das Lab umfasst Container-Orchestrierung, Networking, Storage, Configuration Management, Security, Scaling, Workload Management, Helm und Troubleshooting.

Das Projekt enthält außerdem eine Production-Style-Anwendung, die zunächst mit Kubernetes-Manifests deployed und anschließend in ein wiederverwendbares Helm Chart umgewandelt wurde.

---

## 📌 Projektübersicht

Das Kubernetes Lab wurde erstellt, um praktische Erfahrungen in der Kubernetes-Administration und beim Application Deployment zu sammeln.

Die Umgebung umfasst:

* Kubernetes-Cluster-Management
* Pods, Deployments und ReplicaSets
* Services und internes Networking
* ConfigMaps und Secrets
* PersistentVolumes und PersistentVolumeClaims
* Liveness- und Readiness-Probes
* Resource Requests und Limits
* Horizontal Pod Autoscaling
* Ingress und HTTP Routing
* NetworkPolicies
* RBAC und ServiceAccounts
* StatefulSets und Headless Services
* Jobs und CronJobs
* DaemonSets
* Helm Charts und Releases
* Production-Style Application Deployment
* Troubleshooting und Fehlerszenarien

---

## 🏗️ Architecture

### Architecture Diagram

Das Lab läuft auf einem lokalen Kubernetes-Cluster mit Workload Management, internen Services, persistentem Storage, Networking und Helm-managed Applications.

![Kubernetes Architecture](01-k8s-diagram.png)

---

## 1. ⚙️ Kubernetes Cluster

Die Kubernetes-Umgebung basiert auf einem lokalen Cluster mit einem Control-Plane-Node und den standardmäßigen Kubernetes Control-Plane-Komponenten.

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

Im Lab werden verschiedene Kubernetes-Workload-Typen wie Deployments, Pods, ReplicaSets und StatefulSets verwendet.

Production Workloads verwenden mehrere Replicas, um die Application Availability zu verbessern.

### 📸 Screenshot 03 — Workloads

![Kubernetes Workloads](03-workloads.png)

---

## 3. 🌐 Services & Networking

Kubernetes Services werden verwendet, um Applications bereitzustellen und stabile Netzwerk-Endpunkte bereitzustellen.

Das Lab enthält:

* ClusterIP Services
* NodePort Service
* LoadBalancer Service
* Headless Service

### 📸 Screenshot 04 — Services

![Kubernetes Services](04-services.png)

---

## 4. ⚙️ ConfigMaps & Secrets

Application Configuration und sensible Konfigurationswerte werden mithilfe von Kubernetes ConfigMaps und Secrets getrennt von den Container Images verwaltet.

Die Production Application verwendet beide Ressourcen.

### 📸 Screenshot 05 — ConfigMaps & Secrets

![ConfigMaps and Secrets](05-config-secrets.png)

---

## 5. 💾 Persistent Storage

Persistenter Storage wird mithilfe von PersistentVolumes und PersistentVolumeClaims implementiert.

Die Production Application verwendet eine PVC, die vom lokalen Storage Provisioner bereitgestellt wird.

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

Die Persistence-Funktion wurde getestet, indem der Application Pod neu erstellt und anschließend überprüft wurde, ob der persistente Storage weiterhin verfügbar ist.

![Persistence Test](07-persistence.png)

---

## 6. ❤️ Health Checks

Liveness- und Readiness-Probes werden verwendet, um den Zustand der Application zu überwachen.

* **Liveness Probe** — erkennt, ob ein Container neu gestartet werden sollte.
* **Readiness Probe** — bestimmt, ob ein Pod bereit ist, Traffic zu empfangen.

### 📸 Screenshot 08 — Probes

![Liveness and Readiness Probes](08-probes.png)

---

## 7. 📈 Resources & Autoscaling

Für die Workloads sind Resource Requests und Limits konfiguriert.

Zusätzlich wurde Horizontal Pod Autoscaling implementiert.

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

Ingress wird verwendet, um externen HTTP-Traffic an Kubernetes Services weiterzuleiten.

NetworkPolicies werden verwendet, um die Kommunikation zwischen Pods zu kontrollieren.

Die Production Application enthält eine NetworkPolicy, die den erforderlichen Application Traffic vom Production Client erlaubt.

### 📸 Screenshot 10 — Ingress & NetworkPolicy

![Ingress and NetworkPolicy](10-ingress-network.png)

---

## 9. 🔐 RBAC & ServiceAccounts

Kubernetes RBAC wird verwendet, um den Zugriff auf Cluster-Ressourcen zu kontrollieren.

ServiceAccounts stellen Workloads kontrollierte Identitäten zur Verfügung.

### 📸 Screenshot 11 — RBAC

![RBAC and ServiceAccount](11-rbac.png)

---

## 10. 🖥️ DaemonSet

Ein DaemonSet wird verwendet, um einen Pod auf dem benötigten Kubernetes Node auszuführen.

Das Lab enthält ein `node-agent` DaemonSet.

### 📸 Screenshot 12 — DaemonSet

![DaemonSet](12-daemonset.png)

---

## 11. 🗄️ StatefulSet & Headless Service

Ein StatefulSet wird für Workloads verwendet, die stabile Pod-Identitäten benötigen.

Das Lab enthält:

* `nginx-stateful`
* Zwei StatefulSet Replicas
* Headless Service
* Stabile Pod-Namen

### 📸 Screenshot 13 — StatefulSet

![StatefulSet and Headless Service](13-statefulset.png)

---

## 12. ⏱️ Jobs & CronJobs

Kubernetes Jobs und CronJobs wurden verwendet, um einmalige und geplante Workloads zu demonstrieren.

### 📸 Screenshot 14 — Jobs

![Jobs and CronJobs](14-jobs.png)

---

## 13. ⛵ Helm

Helm wird verwendet, um Kubernetes Applications zu paketieren und zu deployen.

Das Lab enthält zwei Helm Charts:

```text
nginx-chart/
production-app/
```

Die Charts verwenden:

* `Chart.yaml`
* `values.yaml`
* Helm Templates
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

Im aktuellen Cluster sind zwei Helm Releases deployed.

| Release          | Chart                  | Revision | Status   |
| ---------------- | ---------------------- | -------: | -------- |
| `nginx-test`     | `nginx-chart-0.1.0`    |        7 | deployed |
| `production-app` | `production-app-0.1.0` |        4 | deployed |

### 📸 Screenshot 16 — Helm Releases

![Helm Releases](16-helm-releases.png)

---

## 15. 🏭 Production Application

Eine Production-Style-Application wurde mithilfe von Kubernetes-Ressourcen deployed und anschließend in ein Helm Chart umgewandelt.

Die Application umfasst:

* Deployment
* Service
* ConfigMap
* Secret
* PersistentVolumeClaim
* Ingress
* NetworkPolicy
* HPA

Das Production Deployment läuft mit zwei Replicas.

### 📸 Screenshot 17 — Production Stack

![Production Kubernetes Stack](17-production-stack.png)

---

## 16. 🧪 Production Testing

Die Production Application wurde über den konfigurierten Kubernetes Networking Path getestet.

Der Test überprüft, ob die Application erreichbar ist und korrekt antwortet.

### 📸 Screenshot 18 — Production Test

![Production Application Test](18-production-test.png)

---

## 17. ⛑️ Troubleshooting

Das Lab enthält absichtlich fehlerhafte Kubernetes-Ressourcen, um die Diagnose typischer Kubernetes-Probleme zu üben.

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

* Kubernetes Cluster Administration
* Container Orchestration
* Deployment- und ReplicaSet-Management
* Service Networking
* Ingress Configuration
* Configuration- und Secret-Management
* Persistent Storage
* Health Monitoring
* Resource Management
* Horizontal Pod Autoscaling
* Network Security
* RBAC
* Stateful Workloads
* Scheduled Workloads
* DaemonSets
* Helm-based Deployments
* Kubernetes Troubleshooting
* Production-Style Application Deployment

---

## 🚀 Next Steps

* Advanced Kubernetes Networking
* Advanced Helm Templating
* CI/CD Integration mit Kubernetes
* Container Registry Integration
* GitOps Workflows
* Cloud-Kubernetes-Services wie AKS, EKS und GKE

---

## 📌 Project Status

**Status:** Completed ✅

Das Lab demonstriert erfolgreich praktische Kubernetes Administration, Application Deployment, Networking, Storage, Security, Scaling, Helm und Troubleshooting in einer lokalen Kubernetes-Umgebung.
