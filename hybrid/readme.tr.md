# 🔗 Hybrid Cloud Lab

Microsoft Azure, Amazon Web Services ve On-Premises Active Directory ortamlarını bir araya getiren uygulamalı hybrid cloud laboratuvarı.

Projenin amacı cloud platformları ile mevcut Active Directory altyapısı arasında bağlantı kurmak ve farklı cloud ortamlarıyla birlikte çalışan bir hybrid altyapıyı uygulamaktır.

---

## 📌 Proje Genel Bakış

Projede aşağıdaki ortamlar kullanılmaktadır:

* Microsoft Azure
* Amazon Web Services
* On-Premises Active Directory
* Tailscale
* Hybrid Identity
* DNS
* Network Connectivity

On-Premises Active Directory ortamı **Azure ile entegre edilmiştir**.

AWS ortamı ise ayrı bir cloud altyapısı olarak projeye dahil edilmiştir.

---

## 🏗️ Mimari

### Mimari Diyagram

> **[HYBRID CLOUD MİMARİ DİYAGRAMINIZI BURAYA EKLEYİN]**

<!-- Azure + AWS + On-Premises Active Directory + Tailscale mimari diyagramınızı buraya ekleyin -->

Mimari; Azure ve AWS cloud ortamları ile On-Premises Active Directory altyapısından oluşmaktadır.

On-Premises ortam ile Azure arasındaki ağ iletişimi **Tailscale** üzerinden sağlanmaktadır.

---

## 1. ☁️ Microsoft Azure

Azure, hybrid altyapının ana cloud platformlarından biridir.

Azure ortamında Virtual Network, subnet, Windows Server, Private Endpoint, Private DNS ve Managed Identity gibi kaynaklar kullanılmaktadır.

On-Premises Active Directory ortamı Azure ile entegre edilerek hybrid identity senaryosu oluşturulmuştur.

### 📸 Screenshot 01 — Azure Connectivity

![Azure Connectivity](./images/01-azure-connectivity.png)

---

## 2. ☁️ Amazon Web Services

AWS, hybrid cloud portföyünün ikinci cloud platformudur.

AWS ortamında VPC, public/private subnet'ler, EC2, Security Groups ve Application Load Balancer gibi kaynaklar kullanılmaktadır.

AWS altyapısı ayrı bir cloud ortamı olarak yapılandırılmış ve Terraform ile yönetilmektedir.

### 📸 Screenshot 02 — AWS Connectivity

![AWS Connectivity](./images/02-aws-connectivity.png)

---

## 3. 🪟 On-Premises Active Directory

On-Premises Active Directory ortamı Windows Server üzerinde oluşturulmuştur.

Active Directory ortamı **Azure AD Connect** kullanılarak Azure ile entegre edilmiştir.

Kullanıcı kimlikleri Active Directory ile Azure arasında senkronize edilmektedir.

### 📸 Screenshot 03 — Azure AD Connect

![Azure AD Connect](./images/03-azure-ad-connect.png)

### 📸 Screenshot 04 — Synchronization

![Synchronization](./images/04-synchronization.png)

---

## 4. 🔗 Azure — On-Premises Connectivity

On-Premises Active Directory ortamı ile Azure arasındaki ağ iletişimi **Tailscale** üzerinden sağlanmaktadır.

Bu bağlantı sayesinde On-Premises ve Azure ortamları arasında özel ağ üzerinden iletişim kurulması ve bağlantı testlerinin gerçekleştirilmesi sağlanmıştır.

### 📸 Screenshot 05 — Tailscale

![Tailscale](./images/05-tailscale.png)

### 📸 Screenshot 06 — Azure / On-Premises Connectivity Test

![Connectivity Test](./images/06-connectivity-test.png)

---

## 5. 🧪 Hybrid Connectivity Test

Hybrid ortam aşağıdaki bağlantılar üzerinden test edilmektedir:

* On-Premises → Azure
* Azure → On-Premises
* DNS resolution
* Private IP connectivity
* Tailscale connectivity

AWS ortamı ise kendi VPC networking ve cloud servisleri üzerinden ayrıca test edilmektedir.

### 📸 Screenshot 07 — Connectivity Test

![Connectivity Test](./images/07-connectivity-test.png)

### 📸 Screenshot 08 — DNS Test

![DNS Test](./images/08-dns-test.png)

---

## 🛠️ Technologies

**Cloud**

Azure · AWS

**Identity**

Active Directory · Azure AD Connect

**Networking**

VNet · VPC · Subnets · DNS · Tailscale

**Hybrid**

Hybrid Identity · Hybrid Connectivity

**Infrastructure as Code**

Terraform

---

## 📚 Gösterilen Yetkinlikler

* Azure infrastructure
* AWS infrastructure
* Hybrid cloud concepts
* Active Directory integration
* Hybrid identity
* Azure AD Connect
* DNS
* Network connectivity
* Tailscale networking
* Terraform
* Cloud infrastructure troubleshooting

---

## 🚀 Sonraki Adımlar

* Azure + AWS hybrid connectivity'nin geliştirilmesi
* Terraform ile hybrid altyapının genişletilmesi
* Docker entegrasyonu
* Kubernetes ortamının eklenmesi
* Cloud/DevOps otomasyonu

---

## 📌 Proje Durumu

Bu laboratuvar, **Azure, AWS ve On-Premises Active Directory** ortamlarını bir araya getiren sürekli geliştirilen bir hybrid cloud projesidir.

On-Premises Active Directory ile Azure arasındaki bağlantı Tailscale ve Azure AD Connect kullanılarak sağlanmaktadır.
