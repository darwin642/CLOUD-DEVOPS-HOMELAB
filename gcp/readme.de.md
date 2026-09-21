# ☁️ Google Cloud Platform Infrastruktur-Labor

Ein praktisches GCP-Infrastrukturlabor zur Entwicklung von praxisnahen Fähigkeiten in den Bereichen Cloud-Infrastruktur, Netzwerk, Sicherheit, Load Balancing, Identität, Monitoring, Backup, Storage, Autoscaling und hybrider Konnektivität.

Das Hauptziel dieses Labors besteht darin, eine realistische GCP-Infrastrukturumgebung aufzubauen, zu konfigurieren, zu testen und Fehler zu beheben.

---

## 📌 Projektübersicht

Dieses Labor umfasst das Design und die Verwaltung einer kleinen GCP-Infrastrukturumgebung mit öffentlichen und privaten Subnetzen.

Das Projekt umfasst folgende Bereiche:

* Google Cloud VPC
* Öffentliche und private Subnetze
* Firewall Rules
* Compute Engine
* Global Application Load Balancer
* Managed Instance Group
* Autoscaling
* Cloud Storage
* IAM
* Service Accounts
* Cloud DNS
* Private Google Access
* Cloud Monitoring
* Alerting
* Backup und DR
* Storage Lifecycle Management
* Resource Protection
* Private AWS ↔ GCP-Konnektivität
* Netzwerk-Fehlerbehebung

---

## 🏗️ Architektur

### Architekturdiagramm

![GCP Architecture](gcp_diagram.png)

Die Umgebung besteht aus einer VPC mit öffentlichen und privaten Subnetzen, zwei Webservern, einem privaten Application Server und einem öffentlich erreichbaren Global Application Load Balancer.

WEB01 und WEB02 verarbeiten den Webverkehr über den Load Balancer.

APP01 befindet sich in einem privaten Subnetz und besitzt keine öffentliche IP-Adresse.

Die Umgebung enthält außerdem eine Managed Instance Group mit CPU-basierter Autoscaling-Konfiguration.

Die privaten Netzwerke von AWS und GCP sind über Tailscale miteinander verbunden, um die Cloud-übergreifende Konnektivität zu testen.

---

## 1. 🌐 VPC & Subnetze

Die GCP-Netzwerkinfrastruktur wurde mit einer benutzerdefinierten VPC und getrennten öffentlichen und privaten Subnetzen erstellt.

### Konfiguration

| Ressource            | Konfiguration        |
| -------------------- | -------------------- |
| Region               | `europe-west3`       |
| VPC                  | `gcp-lab-vpc`        |
| Öffentliches Subnetz | `gcp-public-subnet`  |
| Public CIDR          | `10.4.0.0/24`        |
| Privates Subnetz     | `gcp-private-subnet` |
| Private CIDR         | `10.4.1.0/24`        |

WEB01 und WEB02 befinden sich im öffentlichen Subnetz, während APP01 im privaten Subnetz betrieben wird.

### 📸 Screenshot 01 — VPC

![VPC](01-vpc.png)

### 📸 Screenshot 02 — Subnetze

![Subnets](02-subnets.png)

### 📸 Screenshot 03 — Firewall-Regeln

![Firewall Rules](03-firewall-rules.png)

---

## 2. 🖥️ Compute Engine Infrastruktur

Compute Engine Instanzen wurden erstellt, um die Web- und Application-Schichten der GCP-Umgebung darzustellen.

### Konfiguration

| Server      | Rolle              | Netzwerk             |
| ----------- | ------------------ | -------------------- |
| `gcp-web01` | Webserver          | Öffentliches Subnetz |
| `gcp-web02` | Webserver          | Öffentliches Subnetz |
| `gcp-app01` | Application Server | Privates Subnetz     |

WEB01 und WEB02 bilden die Webschicht, während APP01 die private Backend-Anwendungsschicht bereitstellt.

### 📸 Screenshot 04 — WEB01

![WEB01](04-web01.png)

### 📸 Screenshot 05 — WEB02

![WEB02](05-web02.png)

### 📸 Screenshot 06 — APP01

![APP01](06-app01.png)

---

## 3. ⚖️ Global Application Load Balancer

Ein Global External Application Load Balancer wurde konfiguriert, um HTTP-Datenverkehr auf die Webschicht zu verteilen.

Der Load Balancer verwendet die Managed Instance Group als Backend und führt HTTP-Health-Checks über den `/health`-Endpunkt durch.

### Konfiguration

| Ressource     | Konfiguration                             |
| ------------- | ----------------------------------------- |
| Load Balancer | Global External Application Load Balancer |
| Frontend      | HTTP                                      |
| Backend       | `gcp-web-backend`                         |
| Health Check  | `gcp-web-health`                          |
| Backend       | `gcp-web-mig`                             |

### 📸 Screenshot 07 — Load Balancer

![Load Balancer](07-load-balancer.png)

### 📸 Screenshot 08 — Backend Service

![Backend Service](08-backend-service.png)

### 📸 Screenshot 09 — Health Check

![Health Check](09-health-check.png)

---

## 4. 📈 Managed Instance Group & Autoscaling

Für die Webschicht wurde eine Managed Instance Group konfiguriert.

Die MIG verwendet ein Instance Template und erstellt automatisch zusätzliche Instanzen, wenn die CPU-Auslastung das konfigurierte Ziel überschreitet.

### Konfiguration

| Ressource                 | Konfiguration         |
| ------------------------- | --------------------- |
| MIG                       | `gcp-web-mig`         |
| Region                    | `europe-west3`        |
| Zone                      | `europe-west3-a`      |
| Mindestanzahl Instanzen   | `2`                   |
| Maximale Anzahl Instanzen | `4`                   |
| CPU-Ziel                  | `60%`                 |
| Instance Template         | `gcp-web-template-v2` |

Autoscaling wurde durch die Erzeugung einer CPU-Last auf einer MIG-Instanz getestet.

Die Gruppe wurde erfolgreich von **2 auf 4 Instanzen** skaliert.

### 📸 Screenshot 10 — Managed Instance Group

![MIG](10-mig.png)

### 📸 Screenshot 11 — Autoscaling

![Autoscaling](11-autoscaling.png)

---

## 5. 🗄️ Cloud Storage

Cloud Storage wurde als Object-Storage-Schicht der Umgebung konfiguriert.

### Konfiguration

| Ressource            | Konfiguration               |
| -------------------- | --------------------------- |
| Bucket               | `gcp-lab-storage-20260920`  |
| Standort             | `europe-west3`              |
| Storage Class        | Standard                    |
| Öffentlicher Zugriff | Nicht öffentlich            |
| Zugriffskontrolle    | Uniform bucket-level access |

Ein Testobjekt wurde erstellt und über den dedizierten VM Service Account von APP01 aus aufgerufen.

### 📸 Screenshot 12 — Cloud Storage Bucket

![Cloud Storage](12-storage.png)

### 📸 Screenshot 13 — Storage Object

![Storage Object](13-storage-object.png)

---

## 6. ♻️ Storage Lifecycle Management

Cloud Storage Lifecycle Management wurde konfiguriert, um Objekte abhängig von ihrem Alter automatisch in kostengünstigere Storage Classes zu verschieben.

### Lifecycle-Regeln

| Alter des Objekts | Storage Class |
| ----------------- | ------------- |
| 30+ Tage          | Nearline      |
| 60+ Tage          | Coldline      |
| 90+ Tage          | Archive       |

Dies demonstriert die automatisierte Verwaltung von Storage-Tiers für die langfristige Datenaufbewahrung.

### 📸 Screenshot 14 — Lifecycle-Regeln

![Lifecycle Rules](14-lifecycle.png)

---

## 7. 🆔 IAM & Service Accounts

Google Cloud IAM wurde zur Kontrolle des Zugriffs auf Cloud-Ressourcen verwendet.

Für die GCP-Lab-VM wurde ein dedizierter Service Account erstellt und mit den minimal erforderlichen Berechtigungen für Cloud Storage ausgestattet.

### Behandelte Themen

* IAM Users
* Least Privilege
* Bucket-Level-Berechtigungen
* Service Accounts
* VM Identity
* Storage Object Viewer

Der VM Service Account wurde von APP01/WEB01 verwendet, um ohne Benutzeranmeldedaten auf den Cloud-Storage-Bucket zuzugreifen.

### 📸 Screenshot 15 — IAM

![IAM](15-iam.png)

### 📸 Screenshot 16 — Service Account

![Service Account](16-service-account.png)

### 📸 Screenshot 17 — Bucket-Berechtigungen

![Bucket Permissions](17-bucket-permissions.png)

---

## 8. 🌐 Private DNS

Cloud DNS wurde mit einer privaten DNS-Zone für die GCP-VPC konfiguriert.

### Konfiguration

| Ressource | Konfiguration                   |
| --------- | ------------------------------- |
| DNS Zone  | `gcp-private-zone`              |
| DNS Name  | `gcp.internal.`                 |
| Netzwerk  | `gcp-lab-vpc`                   |
| Record    | `web01.gcp.internal → 10.4.0.2` |

Der private DNS-Name konnte innerhalb der VPC erfolgreich aufgelöst werden.

### 📸 Screenshot 18 — Private DNS Zone

![Private DNS](18-private-dns.png)

### 📸 Screenshot 19 — DNS Record

![DNS Record](19-dns-record.png)

---

## 9. 🔒 Private Google Access

Private Google Access wurde für das private Subnetz aktiviert.

Dadurch können Instanzen ohne externe IP-Adressen auf unterstützte Google APIs und Services zugreifen.

APP01 konnte erfolgreich auf Cloud Storage zugreifen, ohne eine öffentliche IP-Adresse zu benötigen.

### 📸 Screenshot 20 — Private Google Access

![Private Google Access](20-private-google-access.png)

---

## 10. 📊 Monitoring & Alerting

Cloud Monitoring wurde zur Überwachung der Compute Engine-Metriken verwendet.

Für WEB01 wurde eine Alert Policy für die CPU-Auslastung konfiguriert.

### Behandelte Themen

* Metrics Explorer
* VM CPU Monitoring
* Alert Policies
* E-Mail-Benachrichtigungen
* Schwellenwertbasierte Alarmierung

Das Alerting-System wurde getestet und E-Mail-Benachrichtigungen wurden erfolgreich empfangen.

### 📸 Screenshot 21 — Monitoring Metric

![Monitoring](21-monitoring.png)

### 📸 Screenshot 22 — Alert Policy

![Alert Policy](22-alert-policy.png)

---

## 11. 💾 Backup & Disaster Recovery

Google Cloud Backup and DR wurde zum Schutz von APP01 konfiguriert.

Ein Backup Vault und ein Backup Plan wurden für geplante tägliche Backups erstellt.

### Konfiguration

| Ressource      | Konfiguration      |
| -------------- | ------------------ |
| Backup Vault   | `gcp-lab-vault`    |
| Standort       | `europe-west3`     |
| Backup Plan    | `gcp-app01-backup` |
| Zeitplan       | Daily              |
| Aufbewahrung   | 14 days            |
| Disk Inclusion | All disks          |

### 📸 Screenshot 23 — Backup Vault

![Backup Vault](23-backup-vault.png)

### 📸 Screenshot 24 — Backup Plan

![Backup Plan](24-backup-plan.png)

### 📸 Screenshot 25 — Protected Resource

![Protected Resource](25-protected-resource.png)

---

## 12. 🛡️ Resource Protection

Deletion Protection wurde auf APP01 aktiviert, um eine versehentliche Löschung der VM zu verhindern.

### Konfiguration

| Ressource   | Schutz                      |
| ----------- | --------------------------- |
| `gcp-app01` | Deletion Protection Enabled |

### 📸 Screenshot 26 — Deletion Protection

![Deletion Protection](26-deletion-protection.png)

---

## 13. 🔗 AWS ↔ GCP Private Connectivity

Eine private Netzwerkverbindung zwischen AWS und GCP wurde mithilfe von Tailscale konfiguriert.

Die Verbindung wurde über die privaten IP-Adressen der Webserver getestet.

### Konfiguration

| Cloud     | Private IP   | Tailscale IP    |
| --------- | ------------ | --------------- |
| AWS WEB01 | `10.0.1.124` | `100.64.158.13` |
| GCP WEB01 | `10.4.0.2`   | `100.64.235.92` |

Das Routing zwischen den privaten AWS- und GCP-Netzwerken wurde konfiguriert und erfolgreich getestet.

### 📸 Screenshot 27 — Tailscale Connectivity

![Tailscale Connectivity](27-tailscale-connectivity.png)

### 📸 Screenshot 28 — Private IP Connectivity Test

![Private Connectivity](28-private-connectivity.png)

---

## 14. 🧪 Testing & Troubleshooting

Die GCP-Umgebung wurde anhand realistischer Netzwerk-, Storage-, Load-Balancing- und Infrastruktur-Troubleshooting-Szenarien getestet.

Die Tests umfassten:

* VPC Connectivity
* Connectivity zwischen öffentlichen und privaten Subnetzen
* WEB → APP Connectivity
* Load Balancer Connectivity
* Backend Health Validation
* Cloud Storage Access
* Service Account Permissions
* Private DNS Resolution
* Private Google Access
* Autoscaling
* AWS ↔ GCP Connectivity
* Backup Configuration Validation
* Firewall Rule Validation

### 📸 Screenshot 29 — Network Connectivity Test

![Network Connectivity Test](29-connectivity-test.png)

### 📸 Screenshot 30 — Load Balancer Test

![Load Balancer Test](30-load-balancer-test.png)

### 📸 Screenshot 31 — Autoscaling Test

![Autoscaling Test](31-autoscaling-test.png)

---

## 🛠️ Technologien

**Cloud**

Google Cloud Platform

**Compute**

Compute Engine · Managed Instance Groups

**Networking**

VPC · Subnets · Firewall Rules · Cloud DNS · Load Balancing · Tailscale

**Storage**

Cloud Storage · Nearline · Coldline · Archive · Lifecycle Management

**Identity**

IAM · Service Accounts

**Monitoring**

Cloud Monitoring · Alerting

**Backup**

Backup and DR · Backup Vault

**Betriebssysteme**

Ubuntu Linux

---

## 📚 Nachgewiesene Fähigkeiten

* GCP-Infrastruktur-Deployment
* VPC- und Subnetzdesign
* Firewall-Konfiguration
* Compute Engine Management
* Global Load Balancing
* Managed Instance Groups
* Autoscaling
* Cloud Storage Management
* Storage Lifecycle Management
* IAM und Least-Privilege-Zugriff
* Service Account-Konfiguration
* Private DNS
* Private Google Access
* Cloud Monitoring
* Alerting
* Backup und Disaster Recovery
* Resource Protection
* Cloud-übergreifende Netzwerkkonnektivität
* Netzwerk-Fehlerbehebung
* Fehlerbehebung in Cloud-Infrastrukturen

---

## 🚀 Nächste Schritte

Geplante Erweiterungen für das GCP-Labor:

* GCP Terraform-Infrastruktur
* Erweiterung der hybriden Cloud-Konnektivität
* Container-Technologien
* Docker
* Kubernetes
* Cloud Automation
* Multi-Cloud Infrastructure as Code

---

## 📌 Projektstatus

Dieses Labor ist ein laufendes praxisorientiertes Cloud-Infrastrukturprojekt.

Die GCP-Umgebung wird durch zusätzliche Cloud-Services, Netzwerkszenarien, Automatisierung, Infrastructure as Code und Troubleshooting-Übungen weiterentwickelt.
