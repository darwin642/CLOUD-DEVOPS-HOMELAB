🔗 Hibrit Bulut Laboratuvarı

Microsoft Azure, Amazon Web Services ve On-Premises Active Directory ortamlarını bir araya getiren pratik bir hibrit bulut laboratuvarı.

Projenin amacı, bulut platformlarını mevcut bir On-Premises altyapıya bağlamak ve pratik hibrit bağlantı, hibrit kimlik ve ortamlar arası iletişim senaryolarını göstermektir.

📌 Proje Genel Bakışı

Proje aşağıdaki ortamları ve teknolojileri içermektedir:

Microsoft Azure
Amazon Web Services
On-Premises Active Directory
Tailscale
Hibrit Kimlik
DNS
Ağ Bağlantısı

Üç ortam da hibrit ağ üzerinden birbiriyle iletişim kurabilmektedir.

Ortamdaki en önemli hibrit entegrasyon On-Premises Active Directory ile Microsoft Azure arasındadır.

AWS ortamı ayrı bir bulut altyapısı olarak tutulurken, Tailscale üzerinden genel hibrit ağa katılmaktadır.

🏗️ Mimari

Mimari üç ana ortamdan oluşmaktadır:

☁️ Microsoft Azure
☁️ Amazon Web Services
🪟 On-Premises Active Directory

Her üç ortam da farklı altyapı ortamları arasında ağ bağlantısı sağlayan Tailscale üzerinden birbirine bağlanmaktadır.

Ana hibrit kimlik bağlantısı ise On-Premises Active Directory ile Azure arasında Azure AD Connect üzerinden oluşturulmuştur.

1. 🔗 Hibrit Bağlantı — Tailscale

Tailscale, On-Premises, Azure ve AWS ortamları arasındaki ağ bağlantısı katmanını sağlar.

Her ortam arasında ayrı VPN bağlantıları oluşturmak yerine Tailscale, farklı ortamlardaki sistemlerin iletişim kurmasını sağlayan ortak bir özel ağ sunar.

Bağlantı
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

Tailscale ağ bağlantısı katmanı olarak kullanılırken, gerçek servisler ve kimlikler kendi platformları tarafından yönetilmektedir.

Bu yapı, üç ortam içerisindeki sistemlerin özel ağ bağlantısı kullanarak iletişim kurmasını sağlar.

Kapsanan Konular
Özel ağ bağlantısı
Ortamlar arası iletişim
On-Premises → Azure bağlantısı
On-Premises → AWS bağlantısı
Azure → AWS bağlantısı
Tailscale subnet routing
Hibrit ağ iletişimi

Örneğin, HL-DC01 isimli On-Premises Windows Server makinemiz üzerinden AWS web01 sanal makinesine bağlanabiliriz.

📸 Ekran Görüntüsü — Tailscale Bağlantısı

2. 🪟🔗☁️ On-Premises Active Directory ↔ Azure

Bu, proje içerisindeki ana hibrit entegrasyondur.

On-Premises Windows Server ortamı Active Directory altyapısını barındırırken, Microsoft Azure bulut kimlik ve altyapı bileşenlerini sağlamaktadır.

İki ortam aşağıdaki iki yöntem üzerinden birbirine bağlanmaktadır:

Tailscale üzerinden ağ bağlantısı
Azure AD Connect üzerinden kimlik senkronizasyonu

Bu yapı, On-Premises Active Directory'den gelen kullanıcıların Azure ile senkronize edilebildiği pratik bir hibrit kimlik ortamı oluşturur.

Hibrit Kimlik Akışı
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

Azure AD Connect, On-Premises Active Directory ortamı ile Azure arasındaki kimlikleri senkronize eder.

Bu yapı, bir kuruluşun mevcut On-Premises Active Directory altyapısını korurken kimlik ortamını buluta genişletmesini göstermektedir.

Hibrit Bileşenler
On-Premises Active Directory
Windows Server Domain Controller
Azure AD Connect
Azure kimliği
Kullanıcı senkronizasyonu
Tailscale ağ bağlantısı
📸 Ekran Görüntüsü 01 — Azure AD Connect

📸 Ekran Görüntüsü 02 — Senkronizasyon

3. ☁️ Microsoft Azure

Azure, hibrit altyapı içerisindeki ana bulut platformlarından biridir.

Azure ortamı aşağıdaki bileşenleri içermektedir:

Virtual Network
Subnets
Windows Server
Private Endpoint
Private DNS
Managed Identity

Azure ortamı Tailscale üzerinden On-Premises altyapıya bağlanmaktadır.

Azure ayrıca On-Premises Active Directory ortamıyla entegrasyon sayesinde hibrit kimlik mimarisinin bir parçasıdır.

📸 Ekran Görüntüsü — Azure Bağlantısı

4. ☁️ Amazon Web Services

AWS, hibrit bulut portföyündeki ikinci bulut platformudur.

AWS ortamı aşağıdaki bileşenleri içermektedir:

VPC
Public ve private subnet'ler
EC2
Security Groups
Application Load Balancer

AWS altyapısı ayrı bir bulut ortamı olarak tutulmakta ve Terraform ile yönetilmektedir.

AWS, ortak Tailscale ağı üzerinden On-Premises ve Azure ortamlarına bağlanmaktadır.

Bu yapı, AWS'nin Active Directory kimlik senkronizasyon mimarisinin bir parçası olmadan genel hibrit ağa katılmasını sağlar.

📸 Ekran Görüntüsü — AWS Bağlantısı

5. 🪟 On-Premises Active Directory

On-Premises ortamı Windows Server üzerinde oluşturulmuştur ve kuruluşun merkezi kimlik ve Windows altyapı servislerini sağlamaktadır.

Ortam aşağıdaki bileşenleri içermektedir:

Active Directory Domain Services
DNS
DHCP
Group Policy
File Sharing
Windows istemcileri

Active Directory ortamı Azure AD Connect kullanılarak Azure ile entegre edilmiştir.

Kullanıcı kimlikleri On-Premises Active Directory ile Azure arasında senkronize edilmektedir.

On-Premises ortamı ayrıca Tailscale üzerinden hibrit ağın bir parçası olarak çalışmaktadır.

6. 🌐 Hibrit İletişim

Üç ortam Tailscale ağı üzerinden iletişim kurmaktadır:

                 ┌─────────────────────┐
                 │      TAILSCALE      │
                 │ Hybrid Connectivity │
                 └──────────┬──────────┘
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
          ▼                 ▼                 ▼
   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
   │ ON-PREMISES │   │    AZURE    │   │     AWS     │
   │             │   │             │   │             │
   │ HL-DC01     │◄─►│ Azure VNet  │◄─►│ AWS VPC     │
   │ AD DS       │   │ Azure VM    │   │ EC2         │
   │ DNS / DHCP  │   │             │   │ ALB         │
   └──────┬──────┘   └─────────────┘   └─────────────┘
          │
          │
          │ Azure AD Connect
          │
          ▼
   ┌─────────────────┐
   │ Azure Identity  │
   │ Hybrid Identity │
   └─────────────────┘

Buradaki önemli ayrım, Tailscale'in ağ bağlantısını, Azure AD Connect'in ise kimlik senkronizasyonunu sağlamasıdır.

Bu nedenle:

Tailscale = Ağ Bağlantısı

Azure AD Connect = Hibrit Kimlik

Bu ayrım sayesinde laboratuvar hem hibrit ağ hem de hibrit kimlik yapılarını aynı ortam içerisinde göstermektedir.

📌 Hibrit Lab Odağı

Bu proje On-Premises Active Directory, Microsoft Azure ve AWS ortamlarını birbirine bağlayan pratik bir hibrit altyapıyı göstermektedir.

Ana hibrit entegrasyon On-Premises Active Directory ile Azure arasındadır ve Azure AD Connect kimlik senkronizasyonunu sağlamaktadır.

Ağ katmanında ise Tailscale üç ortamı birbirine bağlayarak On-Premises, Azure ve AWS sistemlerinin hibrit altyapı içerisinde iletişim kurmasını sağlamaktadır.

Proje bu nedenle aşağıdaki konuları göstermektedir:

Hibrit ağ
Hibrit kimlik
Active Directory'nin Azure ile entegrasyonu
Azure AD Connect
Bulutlar arası bağlantı
On-Premises → bulut iletişimi
Azure → AWS iletişimi
AWS → On-Premises iletişimi
Tailscale tabanlı özel ağ bağlantısı
