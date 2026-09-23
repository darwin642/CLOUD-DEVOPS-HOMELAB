# GCP Terraform Implementierung

## Überblick

Dieser Abschnitt dokumentiert die Verwaltung einer bestehenden **Google-Cloud-Platform-(GCP)-Umgebung** mit **Terraform** nach dem Infrastructure-as-Code-Prinzip (IaC).

Im Gegensatz zu einer klassischen Terraform-Bereitstellung, bei der die gesamte Infrastruktur aus Terraform-Konfigurationen erstellt wird, konzentriert sich diese Implementierung auf den Import einer bereits vorhandenen GCP-Infrastruktur in Terraform, die Synchronisierung des Terraform-States mit der tatsächlichen Infrastruktur, die Erkennung von Configuration Drift und die Anpassung der Terraform-Konfiguration an die vorhandenen Ressourcen.

Die Umgebung umfasst Netzwerk-, Compute-, Managed-Instance-Group-, Load-Balancing-, Autoscaling-, Cloud-Storage-, IAM-, Private-DNS-, Monitoring- und Backup-Ressourcen.

Das Hauptziel dieser Implementierung besteht darin, sicherzustellen, dass Terraform die vorhandene Infrastruktur korrekt abbildet und:

```text
terraform plan
```

folgendes Ergebnis liefert:

```text
No changes
```

Damit wird bestätigt, dass die Terraform-Konfiguration und die vorhandene GCP-Infrastruktur synchronisiert sind.

---

# 1. Provider-Konfiguration und Variablen

Der Google-Cloud-Provider wird für die Verwaltung der Ressourcen innerhalb des bestehenden GCP-Projekts konfiguriert.

### Provider-Konfiguration

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
```

Die Umgebung verwendet folgende Konfiguration:

| Einstellung     | Wert                             |
| --------------- | -------------------------------- |
| Cloud Provider  | Google Cloud Platform            |
| Project         | `project-aed44365-ff0a-48b4-b75` |
| Region          | `europe-west3`                   |
| Zone            | `europe-west3-a`                 |
| Google Provider | `~> 7.0`                         |
| Terraform       | `1.15.8`                         |

### Code-Erklärung

* `required_providers` definiert den von Terraform verwendeten Google-Provider.
* `project` identifiziert das GCP-Projekt, in dem sich die Infrastruktur befindet.
* `region` definiert die primäre regionale Umgebung.
* `zone` definiert die Zone für die Compute-Instanzen.
* `~> 7.0` hält den Google-Provider innerhalb der 7.x-Versionen.

---

# 2. Bestehende Infrastruktur und Terraform Import

Die GCP-Umgebung war bereits vorhanden, bevor sie unter Terraform-Verwaltung gestellt wurde.

Anstatt die Infrastruktur neu zu erstellen, wurden die vorhandenen Ressourcen in den Terraform-State importiert.

Der allgemeine Ablauf:

```text
Bestehende GCP-Infrastruktur
          │
          ▼
     Terraform Import
          │
          ▼
     Terraform State
          │
          ▼
      Drift Detection
          │
          ▼
 Konfigurationsabgleich
          │
          ▼
    terraform plan
          │
          ▼
      No changes
```

Dieser Ansatz ermöglicht es Terraform, bereits vorhandene Infrastruktur zu verwalten.

### Terraform Import

Die Ressourcen wurden mit Befehlen wie den folgenden importiert:

```powershell
terraform import google_compute_network.lab_vpc <resource-id>
```

```powershell
terraform import google_compute_instance.web01 <resource-id>
```

```powershell
terraform import google_compute_instance.web02 <resource-id>
```

```powershell
terraform import google_compute_instance.app01 <resource-id>
```

Der gleiche Prozess wurde für Netzwerk-, Load-Balancing-, Storage-, IAM-, Monitoring-, DNS-, Scaling- und Backup-Ressourcen verwendet.

### Code-Erklärung

Terraform Import führt zwei wesentliche Aufgaben aus:

* Es verbindet eine vorhandene Cloud-Ressource mit einer Terraform Resource Address.
* Es speichert Informationen über die Ressource im Terraform-State.

Der Import erstellt jedoch nicht automatisch die Terraform-Konfiguration.

Die Konfiguration muss zusätzlich erstellt werden und die tatsächliche Infrastruktur korrekt abbilden.

---

# 3. VPC und Netzwerk

Die GCP-Umgebung verwendet folgende VPC:

```text
lab_vpc
```

Terraform verwaltet sie beispielsweise mit:

```hcl
resource "google_compute_network" "lab_vpc" {
  name                    = "..."
  auto_create_subnetworks = false
}
```

Die VPC verwendet den Custom-Subnet-Modus, damit Subnetze und regionale Platzierungen explizit kontrolliert werden können.

### Netzwerkarchitektur

```text
                    GCP PROJECT
                         │
                         ▼
                 ┌───────────────┐
                 │    lab_vpc    │
                 │  Custom VPC   │
                 └───────┬───────┘
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
      ┌───────────────┐     ┌───────────────┐
      │ public_subnet │     │private_subnet │
      └───────────────┘     └───────────────┘
              │                     │
         WEB01 / WEB02            APP01
```

Die Custom VPC bildet die Grundlage für die übrigen Komponenten der Umgebung.

---

# 4. Subnetz-Architektur

Terraform verwaltet zwei regionale Subnetze:

* `public_subnet`
* `private_subnet`

Beide befinden sich in:

```text
europe-west3
```

Private Google Access ist für beide Subnetze aktiviert.

```hcl
resource "google_compute_subnetwork" "public_subnet" {
  name                     = "..."
  region                   = var.region
  network                  = google_compute_network.lab_vpc.id
  private_ip_google_access = true
}
```

Die gleiche Konfiguration wird für das private Subnetz verwendet.

### Private Google Access

Private Google Access ermöglicht Instanzen ohne externe IP-Adresse den Zugriff auf unterstützte Google APIs und Dienste über die Google-Infrastruktur.

Dies ist besonders für private Workloads nützlich, die beispielsweise auf Cloud Storage zugreifen müssen, ohne eine öffentliche IP-Adresse zu benötigen.

---

# 5. Firewall und Netzwerksicherheit

Mehrere Firewall-Regeln werden mit Terraform verwaltet, um die Kommunikation zwischen den verschiedenen Komponenten zu kontrollieren.

| Firewall-Regel     | Zweck                                             |
| ------------------ | ------------------------------------------------- |
| `allow_http`       | HTTP-Zugriff auf Webdienste                       |
| `allow_iap_ssh`    | SSH-Zugriff über IAP                              |
| `allow_web_to_app` | Kommunikation zwischen Web- und Application-Layer |
| `allow_app_5000`   | Application-Traffic auf Port 5000                 |
| `app2_http_ns`     | Application-HTTP-Traffic                          |

### Web-to-Application-Kommunikation

```text
Internet
   │
   ▼
Load Balancer
   │
   ├──────────────┐
   ▼              ▼
 WEB01          WEB02
   │              │
   └──────┬───────┘
          │
          │ Application traffic
          ▼
        APP01
```

Die Firewall-Regel `allow_web_to_app` kontrolliert die erforderliche Kommunikation zwischen Web- und Application-Layer.

Damit wird eine grundlegende Netzwerksegmentierung anstelle einer uneingeschränkten Kommunikation zwischen allen Workloads demonstriert.

---

# 6. Compute-Instanzen

Die Umgebung enthält drei zentrale Compute-Engine-Instanzen:

| Instanz | Rolle                |
| ------- | -------------------- |
| `web01` | Web-Workload         |
| `web02` | Web-Workload         |
| `app01` | Application-Workload |

Terraform verwaltet jede Instanz als eigene Ressource.

```hcl
resource "google_compute_instance" "web01" {
  name         = "..."
  machine_type = "..."

  zone = var.zone

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.id
  }
}
```

### Web-Layer

WEB01 und WEB02 stellen den Web-Workload bereit.

Der eingehende Traffic wird über den Google-Cloud-Load-Balancer auf die Instanzen verteilt.

### Application-Layer

APP01 stellt den Application-Workload bereit.

Die Instanz befindet sich im privaten Teil der Architektur und wird nicht direkt aus dem Internet angesprochen.

---

# 7. Instance Template

Terraform verwaltet ein regionales Compute-Engine-Instance-Template:

```text
google_compute_region_instance_template.web_template
```

Das Instance Template stellt eine wiederverwendbare Konfiguration für die Web-Instanzen des Managed Instance Groups bereit.

```text
Instance Template
       │
       ▼
Managed Instance Group
       │
   ┌───┴───┐
   ▼       ▼
 WEB01   WEB02
```

Dadurch können neue Instanzen mit einer konsistenten Konfiguration erstellt werden.

---

# 8. Managed Instance Group

Die Umgebung enthält folgende Managed Instance Group:

```text
web_mig
```

Terraform verwaltet unter anderem:

```hcl
resource "google_compute_region_instance_group_manager" "web_mig" {
  name = "..."

  target_size = 2
}
```

Die aktuelle Zielgröße beträgt:

```text
2 Instanzen
```

Die Managed Instance Group ermöglicht die zentrale Verwaltung mehrerer Instanzen auf Basis des Instance Templates.

### Vorteile

Die MIG bietet:

* Konsistente Instanzkonfiguration
* Zentrale Instanzverwaltung
* Autoscaling-Integration
* Bessere Verfügbarkeit des Web-Layers
* Unterstützung für automatischen Instanzersatz

---

# 9. Autoscaling

Für die Web Managed Instance Group ist Autoscaling konfiguriert.

Terraform verwaltet:

```text
google_compute_autoscaler.web_mig
```

Der Autoscaler kann die Anzahl der Instanzen innerhalb der Managed Instance Group entsprechend der definierten Scaling Policy anpassen.

```text
                 Load / Utilization
                         │
                         ▼
                   Autoscaler
                         │
             ┌───────────┴───────────┐
             ▼                       ▼
       Scale Out                 Scale In
             │                       │
             ▼                       ▼
       More WEB VMs              Fewer WEB VMs
```

Damit wird ein automatischer Skalierungsmechanismus für den Web-Layer bereitgestellt.

---

# 10. Load Balancing

Die GCP-Umgebung verwendet einen globalen HTTP Load Balancer.

Terraform verwaltet folgende Komponenten:

```text
google_compute_health_check.web_health
google_compute_backend_service.web_backend
google_compute_url_map.web_lb
google_compute_target_http_proxy.web_lb
google_compute_global_forwarding_rule.web_lb
```

### Load-Balancer-Architektur

```text
                         INTERNET
                            │
                            ▼
                 Global Forwarding Rule
                            │
                            ▼
                    Target HTTP Proxy
                            │
                            ▼
                        URL Map
                            │
                            ▼
                    Backend Service
                            │
                  ┌─────────┴─────────┐
                  ▼                   ▼
                WEB01               WEB02
```

Die Global Forwarding Rule nimmt eingehenden Traffic entgegen und leitet ihn über die Load-Balancing-Komponenten an den Backend Service weiter.

---

# 11. Health Check

Der Backend Service verwendet folgenden Google-Cloud-Health-Check:

```text
web_health
```

Der Health Check überprüft die Verfügbarkeit der Web-Backends.

```text
Load Balancer
      │
      ▼
 Health Check
      │
 ┌────┴────┐
 ▼         ▼
WEB01     WEB02
```

Dadurch kann der Load Balancer den Traffic an verfügbare Backends weiterleiten.

---

# 12. Web-to-Application-Kommunikation

Web- und Application-Layer sind innerhalb der VPC logisch voneinander getrennt.

```text
                    INTERNET
                       │
                       ▼
                 LOAD BALANCER
                       │
              ┌────────┴────────┐
              ▼                 ▼
            WEB01             WEB02
              │                 │
              └────────┬────────┘
                       │
                 Firewall Rule
                allow_web_to_app
                       │
                       ▼
                     APP01
```

Der Application-Workload muss nicht direkt aus dem Internet erreichbar sein.

Die Kommunikation wird stattdessen über Firewall-Regeln zwischen Web- und Application-Layer kontrolliert.

Dies demonstriert eine grundlegende Multi-Tier-Application-Architektur.

---

# 13. Cloud Storage

Die Umgebung enthält einen von Terraform verwalteten Google-Cloud-Storage-Bucket.

Bucket:

```text
gcp-lab-storage-20260920
```

Der Bucket verwendet:

* Standard Storage Class
* Europe-West3 Location
* Uniform Bucket-Level Access
* Public Access Prevention
* Soft Delete
* Lifecycle Management

### Lifecycle Management

Objekte werden abhängig von ihrem Alter automatisch in verschiedene Storage Classes verschoben.

| Alter des Objekts | Storage Class |
| ----------------- | ------------- |
| 30 Tage           | Nearline      |
| 60 Tage           | Coldline      |
| 90 Tage           | Archive       |

```text
STANDARD
   │
   │ 30 Tage
   ▼
NEARLINE
   │
   │ 60 Tage
   ▼
COLDLINE
   │
   │ 90 Tage
   ▼
ARCHIVE
```

Dies demonstriert automatisiertes Storage Lifecycle Management.

### Bucket-Sicherheit

Public Access Prevention ist aktiviert.

Uniform Bucket-Level Access vereinfacht die IAM-basierte Zugriffskontrolle.

---

# 14. Cloud Storage IAM

Terraform verwaltet die Bucket-IAM-Berechtigungen über:

```text
google_storage_bucket_iam_binding.lab_object_viewer
```

Verwendete Rolle:

```text
roles/storage.objectViewer
```

Zugriff erhalten:

* Das GCP-VM-Service-Account
* Der konfigurierte Benutzer

Dadurch wird der Objektzugriff ermöglicht, ohne unnötige administrative Berechtigungen zu vergeben.

---

# 15. Service Account und IAM

Die Umgebung enthält ein dediziertes Service Account:

```text
gcp-lab-vm
```

Terraform verwaltet es über:

```hcl
resource "google_service_account" "vm_service_account" {
  account_id   = "gcp-lab-vm"
  display_name = "GCP Lab VM Service Account"
}
```

Das Service Account besitzt außerdem die erforderlichen Cloud-Storage-Berechtigungen.

Damit wird ein Identity-Based-Access-Modell anstelle weitreichender Project-Level-Berechtigungen demonstriert.

---

# 16. Private DNS

Die Umgebung enthält eine private Cloud-DNS-Managed-Zone:

```text
gcp-private-zone
```

DNS-Suffix:

```text
gcp.internal.
```

Die Zone ist auf private Sichtbarkeit konfiguriert.

Terraform verwaltet:

```text
google_dns_managed_zone.gcp_private_zone
google_dns_record_set.web01
```

Der WEB01-DNS-Eintrag lautet:

```text
web01.gcp.internal.
```

und verweist auf die private IP-Adresse von WEB01.

```text
web01.gcp.internal.
          │
          ▼
      Private DNS
          │
          ▼
         WEB01
```

Damit wird interne Namensauflösung ermöglicht, ohne den DNS-Eintrag öffentlich bereitzustellen.

---

# 17. Monitoring und Alerting

Cloud Monitoring wird zur Überwachung des Web-Workloads verwendet.

Terraform verwaltet:

```text
google_monitoring_alert_policy.web01_80_cpu
```

Die Alert Policy überwacht die CPU-Auslastung von WEB01.

| Einstellung   | Wert                         |
| ------------- | ---------------------------- |
| Policy        | `web01_80_cpu`               |
| Severity      | WARNING                      |
| Metric        | GCE instance CPU utilization |
| Threshold     | 80%                          |
| Alignment     | 60 Sekunden                  |
| Trigger Count | 1                            |
| Notification  | E-Mail                       |

Wenn die CPU-Auslastung den definierten Schwellenwert überschreitet, wird über den konfigurierten Notification Channel eine E-Mail-Benachrichtigung ausgelöst.

```text
WEB01
  │
  ▼
CPU Utilization
  │
  ▼
> 80%
  │
  ▼
Cloud Monitoring
  │
  ▼
Alert Policy
  │
  ▼
Email Notification
```

---

# 18. Backup Vault

Die Umgebung verwendet Google Cloud Backup and DR zum Schutz der virtuellen Maschinen.

Terraform verwaltet folgenden Backup Vault:

```text
gcp-lab-vault
```

Standort:

```text
europe-west3
```

Der Vault verwendet eine Organization-Level-Access-Restriction und eine minimale Aufbewahrungsdauer.

Der Vault dient als Speicherort für geschützte Compute-Engine-Backups.

---

# 19. Backup Plan

Für APP01 wurde folgender Backup Plan konfiguriert:

```text
gcp-app01-backup
```

### Backup-Konfiguration

| Einstellung   | Wert                    |
| ------------- | ----------------------- |
| Location      | `europe-west3`          |
| Resource Type | Compute Engine Instance |
| Frequency     | Daily                   |
| Time Zone     | Europe/Berlin           |
| Backup Window | 00:00–06:00             |
| Retention     | 14 Tage                 |
| Backup Vault  | `gcp-lab-vault`         |

Architektur:

```text
                    APP01
                      │
                      ▼
                Backup Plan
                      │
                      ▼
                Backup Rule
                      │
                      ▼
                Backup Vault
                      │
                      ▼
                Retained Backups
```

Damit wird ein geplanter Backup-Schutz für APP01 bereitgestellt.

---

# 20. Backup Plan Association

Der Backup Plan ist über folgende Terraform-Ressource mit APP01 verbunden:

```text
google_backup_dr_backup_plan_association.app01
```

Die Association ist aktiv und das zuletzt aufgezeichnete Backup wurde erfolgreich abgeschlossen.

```text
APP01
 │
 ▼
Backup Plan Association
 │
 ▼
gcp-app01-backup
 │
 ▼
gcp-lab-vault
```

Dadurch wird der Compute-Engine-Workload mit der Backup Policy und dem Backup Vault verbunden.

---

# 21. Terraform State

Der Terraform State stellt die Verbindung zwischen Terraform-Konfiguration und der tatsächlichen GCP-Infrastruktur dar.

Der aktuelle Terraform State enthält die importierten Infrastruktur-Ressourcen.

Dazu gehören:

```text
Networking
Compute
Load Balancing
Autoscaling
Storage
IAM
DNS
Monitoring
Backup
```

Der State kann mit folgendem Befehl überprüft werden:

```powershell
terraform state list
```

Die finale Umgebung enthält insgesamt **30 von Terraform verwaltete Ressourcen**.

---

# 22. Terraform Drift Detection

Nach dem Import wurden Terraform-Konfiguration und tatsächliche Infrastruktur miteinander verglichen.

Der Ablauf:

```text
Terraform Configuration
          │
          ▼
    terraform plan
          │
          ▼
Compare with State
          │
          ▼
Compare with GCP
          │
          ▼
Identify Differences
          │
          ▼
Update Configuration
```

Dabei wurden Unterschiede zwischen der vorhandenen Infrastruktur und der ursprünglichen Terraform-Konfiguration erkannt.

Ein Beispiel war die Target Size der Managed Instance Group.

Die vorhandene Umgebung verwendete:

```text
target_size = 2
```

Die Terraform-Konfiguration wurde entsprechend angepasst.

Dies demonstriert, dass Terraform nicht nur für Provisioning, sondern auch zur Erkennung und Abstimmung von Infrastructure Drift verwendet werden kann.

---

# 23. Behandlung des Backup-Association-States

Während des Import-Prozesses wurde bei der Backup Plan Association ein Provider-/State-Synchronisationsproblem beobachtet.

Die GCP-API lieferte die korrekte Compute-Engine-Ressource zurück, während der importierte Terraform State denselben `resource`-Wert nicht beibehielt.

Die erforderliche Konfiguration blieb bestehen:

```hcl
resource = google_compute_instance.app01.id
```

Anschließend wurde folgende Lifecycle-Konfiguration verwendet:

```hcl
lifecycle {
  ignore_changes = [resource]
}
```

Dadurch blieb die erforderliche Konfiguration erhalten, während die vom Provider beobachtete State-Abweichung keine dauerhafte Plan-Änderung mehr erzeugte.

Nach dieser Anpassung erzeugte die Ressource bei `terraform plan` keine fortlaufende Difference mehr.

Dieses Verhalten wird als beobachtete Provider-/State-Synchronisation und nicht als Änderung der eigentlichen Backup-Konfiguration dokumentiert.

---

# 24. Terraform Validation Workflow

Für die abschließende Validierung wurden folgende Befehle verwendet:

```powershell
terraform fmt
```

```powershell
terraform validate
```

```powershell
terraform plan
```

Das wichtigste Endergebnis lautet:

```text
No changes
```

Damit bestätigt Terraform, dass die Konfiguration mit dem Terraform State und der bestehenden GCP-Infrastruktur übereinstimmt.

Der finale Workflow:

```text
terraform fmt
      │
      ▼
terraform validate
      │
      ▼
terraform plan
      │
      ▼
   No changes
```

Für den finalen Synchronisationszustand ist keine Neuerstellung der Infrastruktur erforderlich.

---

# 25. Infrastructure-as-Code-Modell

Diese GCP-Implementierung demonstriert die Verwaltung einer bestehenden Cloud-Infrastruktur nach dem Infrastructure-as-Code-Prinzip.

```text
                 EXISTING GCP
                     │
                     ▼
               Resource Import
                     │
                     ▼
              Terraform State
                     │
                     ▼
              Configuration
                     │
                     ▼
              Drift Detection
                     │
                     ▼
             Configuration Fixes
                     │
                     ▼
               Terraform Plan
                     │
                     ▼
                 No Changes
```

Das zentrale Konzept besteht darin, dass Terraform nicht ausschließlich für die Erstellung neuer Infrastruktur verwendet wird.

Terraform kann auch eingesetzt werden, um bereits vorhandene Infrastruktur unter eine codebasierte Verwaltung zu stellen.

Die finale Konfiguration stellt die GCP-Umgebung reproduzierbar als Code dar, während die bestehenden Ressourcen erhalten bleiben.

---

# 26. Verwaltete GCP-Ressourcen

Der finale Terraform State enthält folgende Ressourcenkategorien:

| Kategorie           | Verwaltete Ressourcen                                               |
| ------------------- | ------------------------------------------------------------------- |
| Networking          | VPC, Public Subnet, Private Subnet                                  |
| Firewall            | HTTP, IAP SSH, Web-to-App, Application Rules                        |
| Compute             | WEB01, WEB02, APP01                                                 |
| Instance Management | Instance Template, Managed Instance Group                           |
| Scaling             | Autoscaler                                                          |
| Load Balancing      | Health Check, Backend Service, URL Map, HTTP Proxy, Forwarding Rule |
| Storage             | Cloud Storage Bucket                                                |
| IAM                 | Service Account, Storage IAM Binding                                |
| DNS                 | Private DNS Zone, WEB01 Record                                      |
| Monitoring          | CPU Alert Policy                                                    |
| Backup              | Backup Vault, Backup Plan, Plan Association                         |

---

# 27. Finale Architektur

Die vollständige GCP-Umgebung kann folgendermaßen dargestellt werden:

```text
                           INTERNET
                              │
                              ▼
                  ┌─────────────────────┐
                  │ Global Forwarding   │
                  │       Rule          │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │  Target HTTP Proxy  │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │       URL Map       │
                  └──────────┬──────────┘
                             │
                             ▼
                  ┌─────────────────────┐
                  │   Backend Service   │
                  └──────────┬──────────┘
                             │
                  ┌──────────┴──────────┐
                  │                     │
                  ▼                     ▼
             ┌─────────┐           ┌─────────┐
             │  WEB01  │           │  WEB02  │
             └────┬────┘           └────┬────┘
                  │                     │
                  └──────────┬──────────┘
                             │
                      Web-to-App FW
                             │
                             ▼
                       ┌─────────┐
                       │  APP01  │
                       └─────────┘

        ┌────────────────────────────────────────┐
        │                lab_vpc                 │
        │                                        │
        │  ┌────────────────┐ ┌───────────────┐  │
        │  │ public_subnet  │ │private_subnet │  │
        │  │ WEB01 / WEB02  │ │     APP01     │  │
        │  └────────────────┘ └───────────────┘  │
        │                                        │
        │  Private Google Access                 │
        │  Private Cloud DNS                     │
        └────────────────────────────────────────┘

        ┌────────────────────────────────────────┐
        │ Additional GCP Services                │
        │                                        │
        │ Cloud Storage                          │
        │ IAM Service Account                    │
        │ Cloud Monitoring                       │
        │ Backup Vault                           │
        │ Backup Plan                            │
        │ Autoscaler / MIG                       │
        └────────────────────────────────────────┘
```

---

# Conclusion

Diese Terraform-Implementierung demonstriert die Verwaltung einer bestehenden GCP-Umgebung nach dem Infrastructure-as-Code-Prinzip.

Das Lab umfasst:

* Import einer bestehenden Infrastruktur
* Terraform-State-Management
* VPC- und Subnetz-Konfiguration
* Firewall-Regeln
* Compute Engine
* Managed Instance Groups
* Autoscaling
* Global HTTP Load Balancing
* Cloud-Storage-Lifecycle-Management
* IAM und Service Accounts
* Private Cloud DNS
* Private Google Access
* Cloud Monitoring
* Backup und Disaster Recovery
* Infrastructure Drift Detection
* Behandlung von Provider-/State-Synchronisation
* Terraform Validation

Der finale Zustand des Projekts wird mit:

```powershell
terraform plan
```

überprüft und liefert:

```text
No changes
```

Damit wird bestätigt, dass die Terraform-Konfiguration mit der bestehenden GCP-Infrastruktur synchronisiert ist und die Umgebung durch Terraform korrekt als Infrastructure as Code dargestellt und verwaltet werden kann.
