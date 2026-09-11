# ☁️ Microsoft Azure Infrastructure Lab

Cloud altyapısı, ağ, güvenlik, kimlik, depolama ve sistem yönetimi alanlarında uygulamalı beceriler geliştirmek amacıyla oluşturulmuş pratik Azure altyapı laboratuvarı.

Laboratuvarın temel amacı gerçekçi bir Azure altyapısının kurulması, yapılandırılması, test edilmesi ve sorunlarının giderilmesidir.

---

## 📌 Proje Genel Bakış

Bu laboratuvar, küçük ölçekli bir Azure altyapı ortamının kurulmasını ve yapılandırılmasını kapsamaktadır.

Projede aşağıdaki konular ele alınmaktadır:

* Azure Virtual Network
* Subnet'ler
* Network Security Groups
* Network routing
* Windows Server Virtual Machine
* Azure Storage
* Private Endpoint
* Private DNS
* Managed Identity
* Azure CLI
* Role-Based Access Control
* Network troubleshooting

---

## 🏗️ Mimari

### Mimari Diyagram

> **[AZURE MİMARİ DİYAGRAMINIZI BURAYA EKLEYİN]**

<!-- Azure mimari diyagramınızı buraya ekleyin -->

Ortam; yapılandırılmış bir subnet yapısına sahip Azure Virtual Network, Windows Server Virtual Machine, ağ güvenlik kontrolleri ve Azure Storage'a özel bağlantıdan oluşmaktadır.

---

## 1. 🌐 Virtual Network & Subnet'ler

Azure ağ altyapısı, özel bir Virtual Network ve yapılandırılmış bir subnet mimarisi kullanılarak oluşturulmuştur.

### Yapılandırma

| Kaynak          | Yapılandırma       |
| --------------- | ------------------ |
| Resource Group  | `rg-az104-lab01`   |
| Virtual Network | `vnet-az104-lab01` |
| Address Space   | `10.0.0.0/16`      |
| Subnet          | `WebSubnet`        |
| Subnet Aralığı  | `10.0.1.0/24`      |
| Region          | Sweden Central     |

### 📸 Screenshot 01 — Resource Group

![Resource Group](./images/01-resource-group.png)

### 📸 Screenshot 02 — Virtual Network

![Virtual Network](./images/02-virtual-network.png)

### 📸 Screenshot 03 — Subnet Yapılandırması

![Subnet Configuration](./images/03-subnet.png)

---

## 2. 🔐 Ağ Güvenliği

Ağ trafiği Network Security Groups kullanılarak kontrol edilmiştir.

Gelen ve giden trafiği kontrol etmek amacıyla WebSubnet'e bir NSG atanmıştır.

### Yapılandırma

* Network Security Group: `nsg-web`
* Subnet bağlantısı: `WebSubnet`
* RDP erişimi yöneticinin public IP adresiyle sınırlandırılmıştır
* Ağ erişimi Security Rules üzerinden kontrol edilmiştir

### 📸 Screenshot 04 — Network Security Group

![Network Security Group](./images/04-nsg.png)

### 📸 Screenshot 05 — NSG Inbound Rules

![NSG Inbound Rules](./images/05-nsg-rules.png)

---

## 3. 🖥️ Windows Server Virtual Machine

Azure Virtual Network içerisinde bir Windows Server Virtual Machine oluşturulmuştur.

### Yapılandırma

| Kaynak            | Yapılandırma                                  |
| ----------------- | --------------------------------------------- |
| VM Name           | `vm-web-01`                                   |
| İşletim Sistemi   | Windows Server 2022 Datacenter: Azure Edition |
| Boyut             | `B2als_v2`                                    |
| Availability Zone | Zone 1                                        |
| Private IP        | `10.0.1.4`                                    |
| Güvenlik          | Trusted Launch                                |

VM; ağ bağlantılarını, Azure servislerini, kimlik doğrulamayı ve Storage erişimini test etmek amacıyla kullanılmaktadır.

### 📸 Screenshot 06 — Virtual Machine Genel Bakış

![Virtual Machine](./images/06-vm-overview.png)

### 📸 Screenshot 07 — VM Networking

![VM Networking](./images/07-vm-networking.png)

---

## 4. 🛣️ Routing

Azure'daki ağ trafiğini ve Next Hop davranışını göstermek amacıyla özel routing yapılandırılmıştır.

### Yapılandırma

| Ayar             | Değer       |
| ---------------- | ----------- |
| Route            | `0.0.0.0/0` |
| Next Hop Type    | Internet    |
| Next Hop Address | `10.0.1.10` |

Routing yapılandırması, ağ laboratuvarı ve troubleshooting senaryolarının bir parçası olarak kullanılmıştır.

### 📸 Screenshot 08 — Route Table

![Route Table](./images/08-route-table.png)

### 📸 Screenshot 09 — Route Configuration

![Route Configuration](./images/09-route.png)

---

## 5. 📦 Azure Storage

Azure Virtual Machine üzerinden güvenli erişimi test etmek amacıyla bir Azure Storage Account oluşturulmuştur.

Storage ortamı Blob Storage ve özel bağlantı yapılandırmasını içermektedir.

### 📸 Screenshot 10 — Storage Account

![Storage Account](./images/10-storage-account.png)

### 📸 Screenshot 11 — Blob Storage

![Blob Storage](./images/11-blob-storage.png)

---

## 6. 🔗 Private Endpoint & Private DNS

Azure Blob Storage'a özel bir ağ bağlantısı sağlamak amacıyla Private Endpoint yapılandırılmıştır.

### Yapılandırma

| Kaynak           | Yapılandırma                        |
| ---------------- | ----------------------------------- |
| Private Endpoint | `pe-storage-01`                     |
| Hedef            | Azure Storage Blob                  |
| Private IP       | `10.0.1.5`                          |
| Private DNS Zone | `privatelink.blob.core.windows.net` |

Bu yapılandırma, public endpoint kullanmadan Azure PaaS servislerine özel erişimi göstermektedir.

### 📸 Screenshot 12 — Private Endpoint

![Private Endpoint](./images/12-private-endpoint.png)

### 📸 Screenshot 13 — Private DNS Zone

![Private DNS](./images/13-private-dns.png)

---

## 7. 🆔 Managed Identity & RBAC

Virtual Machine'a Azure kaynaklarına kontrollü erişim sağlamak amacıyla Managed Identity kullanılmıştır. Böylece kimlik bilgilerini doğrudan VM üzerinde saklamaya gerek kalmamıştır.

VM Identity'ye Blob Storage erişimi için gerekli Azure RBAC yetkisi atanmıştır.

### Role Assignment

* Managed Identity
* Azure Storage
* `Storage Blob Data Reader`

### 📸 Screenshot 14 — Managed Identity

![Managed Identity](./images/14-managed-identity.png)

### 📸 Screenshot 15 — Role Assignment

![Role Assignment](./images/15-role-assignment.png)

---

## 8. 💻 Azure CLI

Azure kaynaklarını Windows Server ortamından yönetmek ve test etmek amacıyla Azure CLI kullanılmıştır.

Laboratuvar kapsamında Azure CLI üzerinden kimlik doğrulama ve Azure kaynaklarıyla etkileşim gerçekleştirilmiştir.

### 📸 Screenshot 16 — Azure CLI

![Azure CLI](./images/16-azure-cli.png)

### 📸 Screenshot 17 — Azure CLI Identity / Resou
