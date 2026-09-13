# 🔗 Hybrid Cloud Lab

**Microsoft Azure, Amazon Web Services ve On-Premises Active Directory ortamlarını** bir araya getiren pratik bir hibrit bulut laboratuvarı.

Projenin amacı, mevcut bir On-Premises altyapıyı bulut platformlarına bağlamak ve pratik **hibrit bağlantı, hibrit kimlik ve ortamlar arası iletişim** senaryolarını göstermektir.

---

## 📌 Proje Genel Bakış

Projede aşağıdaki ortamlar ve teknolojiler kullanılmaktadır:

* Microsoft Azure
* Amazon Web Services
* On-Premises Active Directory
* Tailscale
* Hybrid Identity
* DNS
* Network Connectivity

Üç ortam da hibrit ağ üzerinden birbiriyle iletişim kurabilmektedir.

Ortam içerisindeki en önemli hibrit entegrasyon **On-Premises Active Directory ile Microsoft Azure** arasındadır.

AWS ortamı ayrı bir bulut altyapısı olarak yönetilirken, Tailscale üzerinden genel hibrit ağa dahil olmaktadır.

---

## 🏗️ Architecture

![Tailscale Connectivity](hybrid-diagram.png)

Mimari üç ana ortamdan oluşmaktadır:

* ☁️ Microsoft Azure
* ☁️ Amazon Web Services
* 🪟 On-Premises Active Directory

Her üç ortam da farklı altyapılar arasında ağ bağlantısı sağlayan **Tailscale** üzerinden birbirine bağlanmaktadır.

Ana hibrit kimlik bağlantısı ise **On-Premises Active Directory ile Azure** arasında Azure AD Connect kullanılarak oluşturulmuştur.

---

## 1. 🔗 Hybrid Connectivity — Tailscale

**Tailscale, On-Premises, Azure ve AWS ortamları arasındaki ağ bağlantısını sağlayan katmandır.**

Her ortam arasında ayrı VPN bağlantıları oluşturmak yerine Tailscale, farklı altyapılardaki sistemlerin iletişim kurmasını sağlayan ortak bir özel ağ oluşturur.

### Connectivity

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
