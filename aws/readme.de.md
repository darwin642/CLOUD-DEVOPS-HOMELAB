# ☁️ Amazon Web Services Infrastructure Lab

Ein praktisches AWS-Infrastruktur-Labor, das entwickelt wurde, um praktische Kenntnisse in den Bereichen Cloud-Infrastruktur, Netzwerk, Sicherheit, Load Balancing, Identitätsverwaltung, Monitoring, Backup und Infrastructure as Code zu entwickeln.

Das Hauptziel dieses Labors ist der Aufbau, die Konfiguration, das Testen und die Fehlerbehebung einer realistischen AWS-Infrastruktur.

---

## 📌 Projektübersicht

Dieses Labor umfasst den Aufbau und die Verwaltung einer kleinen AWS-Infrastruktur mit einer Multi-AZ-Architektur.

Das Projekt behandelt folgende Bereiche:

* Amazon VPC
* Öffentliche und private Subnetze
* Internet Gateway
* Route Tables
* EC2
* Security Groups
* Application Load Balancer
* IAM
* CloudWatch
* AWS Backup
* Multi-AZ-Architektur
* Terraform
* Netzwerk-Fehlerbehebung

---

## 🏗️ Architektur

### Architekturdiagramm

> **[IHR AWS-ARCHITEKTURDIAGRAMM HIER EINFÜGEN]**

<!-- AWS-Architekturdiagramm hier einfügen -->

Die Umgebung besteht aus einer VPC mit öffentlichen und privaten Subnetzen, zwei Webservern, einem privaten Application Server und einem öffentlichen Application Load Balancer.

WEB01 und WEB02 befinden sich in unterschiedlichen Availability Zones und verarbeiten den Webverkehr über den Application Load Balancer.

APP01 befindet sich in einem privaten Subnetz und besitzt keine öffentliche IP-Adresse.

---

## 1. 🌐 VPC & Subnetze

Die AWS-Netzwerkinfrastruktur wurde mit einer eigenen VPC sowie einer Architektur aus öffentlichen und privaten Subnetzen erstellt.

### Konfiguration

| Ressource            | Konfiguration    |
| -------------------- | ---------------- |
| Region               | `eu-north-1`     |
| VPC                  | `AWS-LAB-VPC`    |
| CIDR                 | `10.0.0.0/16`    |
| Öffentliche Subnetze | `WEB01`, `WEB02` |
| Privates Subnetz     | `APP01`          |
| Internet Gateway     | `AWS-LAB-IGW`    |

WEB01 und WEB02 befinden sich in öffentlichen Subnetzen, während APP01 in einem privaten Subnetz betrieben wird.

WEB02 wurde in einer anderen Availability Zone bereitgestellt, um eine Multi-AZ-Architektur zu demonstrieren.

### 📸 Screenshot 01 — VPC

![VPC](./images/01-vpc.png)

### 📸 Screenshot 02 — Subnetze

![Subnets](./images/02-subnets.png)

### 📸 Screenshot 03 — Route Tables

![Route Tables](./images/03-route-tables.png)

### 📸 Screenshot 04 — Internet Gateway

![Internet Gateway](./images/04-internet-gateway.png)

---

## 2. 🖥️ EC2-Infrastruktur

EC2-Instanzen wurden erstellt, um die Web- und Application-Ebene der AWS-Umgebung darzustellen.

### Konfiguration

| Server  | Rolle              | Netzwerk             |
| ------- | ------------------ | -------------------- |
| `WEB01` | Webserver          | Öffentliches Subnetz |
| `WEB02` | Webserver          | Öffentliches Subnetz |
| `APP01` | Application Server | Privates Subnetz     |

WEB01 und WEB02 bilden die öffentlich erreichbare Web-Ebene, während APP01 die private Application-Ebene darstellt.

### 📸 Screenshot 05 — WEB01

![WEB01](./images/05-web01.png)

### 📸 Screenshot 06 — WEB02

![WEB02](./images/06-web02.png)

### 📸 Screenshot 07 — APP01

![APP01](./images/07-app01.png)

---

## 3. 🔐 Security Groups

Der Netzwerkzugriff auf die EC2-Instanzen wird mithilfe von Security Groups kontrolliert.

Für die Web- und Application-Server wurden separate Sicherheitsregeln konfiguriert.

### Konfiguration

* `WEB01-SG`
* `APP01-SG`
* Erforderlicher Netzwerkzugriff für die Webserver
* APP01 innerhalb des privaten Netzwerks
* Verkehrssteuerung über Security-Group-Regeln

APP01 besitzt keine öffentliche IP-Adresse.

### 📸 Screenshot 08 — WEB01 Security Group

![WEB01 Security Group](./images/08-web01-sg.png)

### 📸 Screenshot 09 — APP01 Security Group

![APP01 Security Group](./images/09-app01-sg.png)

---

## 4. ⚖️ Application Load Balancer

Ein Application Load Balancer wurde konfiguriert, um Load Balancing und hohe Verfügbarkeit innerhalb der Web-Ebene zu demonstrieren.

Der ALB verwendet WEB01 und WEB02 als Targets.

Der Datenverkehr wird zwischen Webservern in unterschiedlichen Availability Zones verteilt.

### Konfiguration

| Ressource          | Konfiguration             |
| ------------------ | ------------------------- |
| Load Balancer      | Application Load Balancer |
| Targets            | `WEB01`, `WEB02`          |
| Availability Zones | Multi-AZ                  |
| Backend            | EC2 Webserver             |

### 📸 Screenshot 10 — Application Load Balancer

![Application Load Balancer](./images/10-load-balancer.png)

### 📸 Screenshot 11 — Target Group

![Target Group](./images/11-target-group.png)

---

## 5. 🆔 IAM

AWS Identity and Access Management wurde verwendet, um den Zugriff auf AWS-Ressourcen zu kontrollieren.

IAM-Benutzer und Berechtigungen wurden konfiguriert, um Identity- und Access-Management zu demonstrieren.

### Behandelte Themen

* IAM Users
* IAM Permissions
* Zugriffskontrolle
* Least-Privilege-Prinzip

### 📸 Screenshot 12 — IAM Users

![IAM Users](./images/12-iam-users.png)

### 📸 Screenshot 13 — IAM Permissions

![IAM Permissions](./images/13-iam-permissions.png)

---

## 6. 📊 Monitoring & CloudWatch

Amazon CloudWatch wurde zur Überwachung der AWS-Infrastruktur verwendet.

EC2-Metriken wurden überwacht und ein Alarm für eine ausgewählte Metrik eingerichtet.

### Behandelte Themen

* CloudWatch Metrics
* Monitoring
* Metric Alarms
* Infrastructure Monitoring

### 📸 Screenshot 14 — CloudWatch Metric

![CloudWatch Metric](./images/14-cloudwatch-metric.png)

### 📸 Screenshot 15 — CloudWatch Alarm

![CloudWatch Alarm](./images/15-cloudwatch-alarm.png)

---

## 7. 💾 AWS Backup

AWS Backup wurde verwendet, um ein zentrales Backup-Management für AWS-Ressourcen zu demonstrieren.

Ein Backup Plan wurde erstellt und eine Backup-Konfiguration für die entsprechende Ressource eingerichtet.

### Behandelte Themen

* Backup Plan
* Backup-Konfiguration
* Resource Assignment
* Backup Management

### 📸 Screenshot 16 — Backup Plan

![Backup Plan](./images/16-backup-plan.png)

### 📸 Screenshot 17 — Backup Resource

![Backup Resource](./images/17-backup-resource.png)

---

## 8. 🏗️ Terraform

Terraform wurde verwendet, um die AWS-Infrastruktur nach dem Infrastructure-as-Code-Prinzip zu verwalten.

Vorhandene AWS-Ressourcen wurden in den Terraform State importiert, sodass die Infrastruktur deklarativ verwaltet werden kann.

### Terraform-Bereich

* VPC
* Internet Gateway
* Route Tables
* Subnetze
* Security Groups
* Terraform State
* Resource Dependencies
* Infrastructure Planning
* Infrastructure Management

Terraform wurde verwendet, um den aktuellen Zustand der Infrastruktur zu überprüfen und Änderungen vor dem Deployment zu planen.

### 📸 Screenshot 18 — Terraform Plan

![Terraform Plan](./images/18-terraform-plan.png)

### 📸 Screenshot 19 — Terraform State

![Terraform State](./images/19-terraform-state.png)

---

## 9. 🧪 Tests & Fehlerbehebung

Die AWS-Umgebung wurde anhand realistischer Netzwerk- und Infrastructure-Troubleshooting-Szenarien getestet.

Durchgeführte Tests:

* VPC-Netzwerkverbindung
* Verbindung zu öffentlichen Subnetzen
* Verbindung zu privaten Subnetzen
* WEB01 → APP01 Verbindung
* WEB02 → APP01 Verbindung
* Überprüfung der Security Groups
* Überprüfung der Route Tables
* Internet-Gateway-Konnektivität
* Load-Balancer-Konnektivität
* Überprüfung des Target-Status
* EC2 Network Troubleshooting

Die Verbindung zu APP01 wurde innerhalb des privaten Netzwerks ohne öffentliche IP-Adresse getestet.

### 📸 Screenshot 20 — Netzwerkverbindungstest

![Network Connectivity Test](./images/20-connectivity-test.png)

### 📸 Screenshot 21 — Load-Balancer-Test

![Load Balancer Test](./images/21-load-balancer-test.png)

### 📸 Screenshot 22 — Target Health

![Target Health](./images/22-target-health.png)

---

## 🛠️ Technologien

**Cloud**

AWS

**Infrastructure**

Amazon VPC · EC2 · AWS Backup

**Networking**

VPC · Subnetze · Route Tables · Internet Gateway · Security Groups · Load Balancing · Multi-AZ

**Identity**

IAM

**Monitoring**

CloudWatch

**Infrastructure as Code**

Terraform

**Betriebssysteme**

Windows Server · Linux

---

## 📚 Gezeigte Kenntnisse

* Aufbau einer AWS-Infrastruktur
* VPC-Design
* Design öffentlicher und privater Subnetze
* Verwaltung von Route Tables
* Konfiguration eines Internet Gateways
* EC2-Verwaltung
* Konfiguration von Security Groups
* Application Load Balancing
* Multi-AZ-Architektur
* IAM-Verwaltung
* CloudWatch Monitoring
* AWS Backup
* Terraform
* Infrastructure as Code
* Netzwerk-Fehlerbehebung
* Cloud-Infrastruktur-Troubleshooting

---

## 🚀 Nächste Schritte

Geplante Erweiterungen des AWS-Labors:

* Hybrid Connectivity zwischen AWS und Azure
* Integration von Active Directory
* Erweiterung der Terraform-Infrastruktur
* Container-Technologien
* Docker
* Kubernetes
* Cloud Automation
* AWS + Azure Hybrid Cloud

---

## 📌 Projektstatus

Dieses Labor ist ein fortlaufendes praktisches Cloud-Infrastrukturprojekt.

Die Umgebung wird durch zusätzliche AWS-Services, Netzwerk-Szenarien, Automatisierung, Infrastructure as Code und Troubleshooting-Übungen kontinuierlich erweitert.
