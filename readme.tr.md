# ☁️ Cloud & DevOps Lab Portföyü

Bu portföy, IT Support alanından Cloud Infrastructure ve DevOps alanına olan gelişimimi uygulamalı çalışmalar üzerinden belgelemektedir.

Bu portföy; yalnızca teori çalışmak yerine gerçek dünya altyapılarını oluşturma, yapılandırma, sorun giderme ve otomasyon süreçlerine odaklanmaktadır.

Aşağıda üzerinde çalıştığım ortamların görsel bir özeti bulunmaktadır:

![Cloud & DevOps Lab Environments](main_diagram.png)

---

## ☁️ Cloud Platformları

### Microsoft Azure

Aşağıdaki konuları kapsayan uygulamalı Azure altyapı laboratuvarı:

* Azure Virtual Networks
* Subnetler
* Network Security Groups
* Sanal Makineler
* Routing
* Private Endpoints
* Managed Identities
* Azure Storage
* Azure CLI
* Windows Server

[Azure Lab'ını Gör →](az/readme.en.md)

---

### Amazon Web Services

Aşağıdaki konuları kapsayan uygulamalı AWS altyapı laboratuvarı:

* VPC
* Public ve private subnetler
* Internet Gateway
* Route Tables
* EC2
* Application Load Balancer
* Security Groups
* IAM
* Systems Manager
* VPC Endpoints
* CloudWatch
* SNS
* S3
* Multi-AZ mimarisi

Altyapı Terraform ile yönetilmektedir.

[AWS Lab'ını Gör →](aws/readme.en.md)

---

### Google Cloud Platform

Aşağıdaki konuları kapsayan uygulamalı GCP altyapı laboratuvarı:

* VPC
* Public ve private subnetler
* Compute Engine
* Global Application Load Balancer
* Managed Instance Group & Autoscaling
* Cloud Storage & Lifecycle Management
* IAM & Service Accounts
* Cloud DNS
* Private Google Access
* Cloud Monitoring & Alerting
* Backup & Disaster Recovery
* AWS ↔ GCP private bağlantısı

[GCP Lab'ını Gör →](gcp/readme.en.md)

---

## 🪟 Windows & Identity

### Active Directory

Aşağıdaki konuları kapsayan uygulamalı Windows Server ve Active Directory ortamı:

* Active Directory Domain Services
* DNS
* DHCP
* Group Policy
* Organizational Units
* Kullanıcı ve bilgisayar yönetimi
* PowerShell
* Windows Server yönetimi

[Active Directory Lab'ını Gör →](ad/readme.en.md)

---

## 🔗 Hybrid Cloud

### Azure + AWS + Active Directory + Tailscale

Cloud platformlarını on-premises kimlik ve altyapı ile birleştiren hibrit bir altyapı projesi.

Proje şu konulara odaklanmaktadır:

* Hybrid Identity
* Active Directory entegrasyonu
* Azure
* AWS
* Tailscale
* DNS
* Networking
* Cloud Connectivity
* Platformlar arası altyapı

[Hybrid Cloud Lab'ını Gör →](hybrid/readme.en.md)

---

## 🏗️ Infrastructure as Code

### Terraform

Deklaratif yapılandırma kullanarak cloud altyapısını yönetmeye odaklanan uygulamalı Infrastructure as Code çalışmaları.

Mevcut çalışmalar:

* AWS altyapısı
* VPC networking
* EC2
* Load Balancing
* IAM
* Monitoring
* Storage
* Variables ve Locals
* Data Sources
* Resource Dependencies
* Terraform State Management
* Infrastructure Planning ve Deployment

[Terraform Lab'ını Gör →](terraform/readme.en.md)

---

## ⚙️ Automation & Configuration Management

### Ansible

Ansible kullanılarak yapılan uygulamalı configuration management ve otomasyon çalışmaları.

Mevcut çalışmalar:

* Ansible Roles
* Playbooks
* Service Management
* Paket kurulumu
* Templates
* Handlers
* UFW Firewall Configuration
* Idempotent Configuration

[Ansible Lab'ını Gör →](ansible/readme.en.md)

### Python

AWS/GCP inventory, health checks, JSON raporlama, API kullanımı ve otomatik testler dahil olmak üzere cloud otomasyonu ve altyapı görevlerinde kullanılmaktadır.

### Bash

Linux sistem yönetimi ve otomasyon görevlerinde kullanılmaktadır.

### PowerShell

Windows sistem yönetimi, Active Directory ve otomasyon görevlerinde kullanılmaktadır.

---

## 🐳 Containers

### Docker

Container uygulamalarını oluşturma, çalıştırma ve yönetmeye odaklanan uygulamalı containerization çalışmaları.

Mevcut çalışmalar:

* Docker Images ve Containers
* Dockerfiles ve Multi-Stage Builds
* Volumes ve Networks
* Docker Compose
* Nginx ve PostgreSQL
* Docker Security ve Secrets
* Docker Hub ve CI/CD

[Docker Lab'ını Gör →](docker/readme.en.md)

---

## ☸️ Container Orchestration

### Kubernetes

Aşağıdaki konuları kapsayan uygulamalı Kubernetes laboratuvarı:

* Pods, Deployments & Services
* ConfigMaps & Secrets
* Storage & Networking
* Ingress & NetworkPolicies
* HPA & RBAC
* StatefulSets, DaemonSets & Jobs
* Helm
* Production Deployment & Troubleshooting

[Kubernetes Lab'ını Gör →](kubernetes/readme.en.md)

---

## 🔄 CI/CD

### GitHub Actions

GitHub Actions kullanılarak yapılan uygulamalı CI/CD otomasyon çalışmaları.

Mevcut çalışmalar:

* Otomatik testler
* Docker image build işlemleri
* GitHub Container Registry
* Self-hosted runners
* Otomatik deployment
* CI/CD pipeline'ları

[CI/CD Lab'ını Gör →](cicd/readme.en.md)

---

## 📊 Monitoring & Observability

Container ortamları için oluşturulmuş uygulamalı monitoring altyapısı.

Mevcut çalışmalar:

* Prometheus
* PromQL
* cAdvisor
* Container metrikleri
* CPU ve memory monitoring
* Network metrikleri
* Grafana dashboard'ları
* Alerting
* Docker monitoring

[Monitoring Lab'ını Gör →](monitor/readme.en.md)

---

## 📝 Cloud Sistem Karşılaştırmaları

Çalıştığım cloud platformlarının aşağıdaki kriterlere göre yaptığım uygulamalı karşılaştırması:

* GUI / Console deneyimi
* Navigasyon kolaylığı
* Dokümantasyon
* CLI deneyimi
* Networking
* IAM ve yetkilendirme
* Monitoring
* Troubleshooting
* Öğrenme eğrisi
* Genel kullanıcı deneyimi

[Siteyi Gör →](hm/readme.en.md)

---

## 🛠️ Teknolojiler

**Cloud**

Azure · AWS · GCP

**Infrastructure as Code**

Terraform

**Automation & Configuration Management**

Ansible · Python · Bash · PowerShell

**Containers**

Docker · Kubernetes

**CI/CD**

GitHub Actions

**Monitoring & Observability**

Prometheus · Grafana · cAdvisor

**Networking**

VNet · VPC · Subnets · Routing · NSGs · Security Groups · Load Balancing · DNS · Tailscale

**Identity & Systems**

Active Directory · IAM · Windows Server · Linux · Group Policy

---

## 🎯 Öğrenme Yolculuğu

```text
IT Support
    │
    ▼
Microsoft Azure
    │
    ▼
Active Directory
    │
    ▼
   AWS
    │
    ▼
Hybrid Cloud
    │
    ▼
Terraform
    │
    ▼
  Docker
    │
    ▼
Kubernetes
    │
    ▼
Automation & CI/CD
    │
    ▼
Monitoring
    │
    ▼
Cloud / DevOps
```

---

## 📌 Bu Portföy Hakkında

Bu portföy, Cloud Infrastructure ve DevOps alanındaki yetkinliklerimi geliştirirken oluşturduğum uygulamalı laboratuvar çalışmalarını belgelemektedir.

Her proje; yapılandırma, test, sorun giderme ve otomasyon süreçleri üzerinden pratik bilgiyi geliştirmek amacıyla tasarlanmıştır.

Yeni teknolojiler ve projeler eklendikçe portföy sürekli olarak geliştirilmeye devam edecektir.
