# 🔗 Hibrit Bulut Laboratuvarı

**Microsoft Azure, Amazon Web Services ve On-Premises Active Directory ortamını** bir araya getiren pratik bir hibrit bulut laboratuvarı.

Projenin amacı, bulut platformlarını mevcut **On-Premises altyapısıyla** birbirine bağlamak ve pratik **hibrit bağlantı, hibrit kimlik ve ortamlar arası iletişim** senaryolarını göstermektir.

---

## 📌 Proje Genel Bakışı

Proje aşağıdaki ortamları ve teknolojileri içermektedir:

* Microsoft Azure
* Amazon Web Services
* On-Premises Active Directory
* Tailscale
* Hibrit Kimlik
* DNS
* Ağ Bağlantısı

Üç ortam da hibrit ağ üzerinden birbiriyle iletişim kurabilmektedir.

Ortamdaki en önemli hibrit entegrasyon, **On-Premises Active Directory ile Microsoft Azure** arasındadır.

AWS ortamı ayrı bir bulut altyapısı olarak tutulurken, Tailscale üzerinden genel hibrit ağa dahil olmaktadır.

---

## 🏗️ Mimari

![Tailscale Bağlantısı](hybrid-diagram.png)

Mimari üç ana ortamdan oluşmaktadır:

* ☁️ Microsoft Azure
* ☁️ Amazon Web Services
* 🪟 On-Premises Active Directory

Her üç ortam da **Tailscale** üzerinden birbirine bağlanarak farklı altyapı ortamları arasında ağ bağlantısı sağlamaktadır.

Ana hibrit kimlik bağlantısı, **On-Premises Active Directory ile Azure** arasında Azure AD Connect üzerinden oluşturulmuştur.

---

## 1. 🔗 Hibrit Bağlantı — Tailscale

**Tailscale, On-Premises, Azure ve AWS ortamları arasındaki ağ bağlantısı katmanını sağlar.**

Her ortam arasında ayrı VPN bağlantıları oluşturmak yerine Tailscale, farklı altyapı ortamlarındaki sistemlerin iletişim kurmasını sağlayan ortak bir özel ağ sunar.

### Bağlantı

```text
                    HYBRID NETWORK
                         │
                  ┌──────▼──────┐
                  │  Tailscale  │
                  │ Private VPN │
                  └──────┬──────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
   ON-PREMISES        AZURE            AWS
   Active Directory   VNet             VPC
   Windows Server     Azure VM         EC2
```

Tailscale **ağ bağlantısı katmanı** olarak kullanılırken, gerçek servisler ve kimlikler kendi platformları tarafından yönetilmeye devam etmektedir.

Bu yapı, üç ortam içerisindeki sistemlerin özel ağ bağlantısı üzerinden iletişim kurmasını sağlar.

### Kapsanan Konular

* Özel ağ bağlantısı
* Ortamlar arası iletişim
* On-Premises → Azure bağlantısı
* On-Premises → AWS bağlantısı
* Azure → AWS bağlantısı
* Tailscale subnet routing
* Hibrit ağ iletişimi

Örneğin, On-Premises Windows Server makinemiz olan **"HL-DC01"** üzerinden AWS web01 sanal makinesine bağlanabiliyoruz.

### 📸 Ekran Görüntüsü — Tailscale Bağlantısı

![Tailscale Bağlantısı](tailscale-connectivity.png)

---

## 2. 🪟🔗☁️ On-Premises Active Directory ↔ Azure

Bu, proje içerisindeki **ana hibrit entegrasyondur**.

On-Premises Windows Server ortamı Active Directory altyapısını barındırırken, Microsoft Azure bulut kimliği ve altyapı bileşenlerini sağlamaktadır.

İki ortam şu iki yapı üzerinden birbirine bağlanmaktadır:

* **Tailscale üzerinden ağ bağlantısı**
* **Azure AD Connect üzerinden kimlik senkronizasyonu**

Bu yapı, On-Premises Active Directory'den kaynaklanan kullanıcıların Azure ile senkronize edilebildiği pratik bir **hibrit kimlik ortamı** oluşturur.

### Hibrit Kimlik Akışı

```text
        ON-PREMISES
             │
             │
     ┌───────▼─────────┐
     │   HL-DC01       │
     │ Windows Server  │
     │                 │
     │ Active Directory│
     └────────┬────────┘
              │
              │ Azure AD Connect
              │
              ▼
     ┌──────────────────┐
     │ Microsoft Azure  │
     │                  │
     │ Azure Identity   │
     │ Cloud Resources  │
     └──────────────────┘
```

Azure AD Connect, On-Premises Active Directory ortamı ile Azure arasındaki kimlikleri senkronize eder.

Bu yapı, bir kuruluşun mevcut On-Premises Active Directory altyapısını korurken kimlik ortamını buluta genişletebilmesini göstermektedir.

### Hibrit Bileşenler

* On-Premises Active Directory
* Windows Server Domain Controller
* Azure AD Connect
* Azure kimliği
* Kullanıcı senkronizasyonu
* Tailscale ağ bağlantısı

### 📸 Ekran Görüntüsü 01 — Azure AD Connect

![Azure AD Connect](azure-ad-connect2.png)

### 📸 Ekran Görüntüsü 02 — Senkronizasyon

![Senkronizasyon](azure-ad-sync.png)

---

## 3. ☁️ Microsoft Azure

Azure, hibrit altyapı içerisindeki ana bulut platformlarından biridir.

Azure ortamı aşağıdaki bileşenleri içermektedir:

* Virtual Network
* Subnet'ler
* Windows Server
* Private Endpoint
* Private DNS
* Managed Identity

Azure ortamı, Tailscale üzerinden On-Premises altyapısına bağlanmaktadır.

Azure ayrıca On-Premises Active Directory ortamıyla entegrasyon üzerinden hibrit kimlik mimarisine dahil olmaktadır.

### 📸 Ekran Görüntüsü — Azure Bağlantısı

![Azure Bağlantısı](azure-connectivity.png)

---

## 4. ☁️ Amazon Web Services

AWS, hibrit bulut portföyündeki ikinci bulut platformudur.

AWS ortamı aşağıdaki bileşenleri içermektedir:

* VPC
* Public ve private subnet'ler
* EC2
* Security Groups
* Application Load Balancer

AWS altyapısı ayrı bir bulut ortamı olarak tutulmakta ve Terraform ile yönetilmektedir.

AWS, ortak Tailscale ağı üzerinden On-Premises ve Azure ortamlarına bağlanmaktadır.

Bu yapı, AWS'nin Active Directory kimlik senkronizasyon mimarisinin bir parçası olmadan genel hibrit ağa dahil olmasını sağlar.

### 📸 Ekran Görüntüsü — AWS Bağlantısı

![AWS Bağlantısı](aws-connectivity.png)

---

## 5. 🪟 On-Premises Active Directory

On-Premises ortamı Windows Server üzerinde kurulmuştur ve kuruluşun merkezi kimlik ve Windows altyapı servislerini sağlamaktadır.

Ortam aşağıdaki bileşenleri içermektedir:

* Active Directory Domain Services
* DNS
* DHCP
* Group Policy
