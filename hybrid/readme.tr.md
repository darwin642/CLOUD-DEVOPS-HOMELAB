🔗 Hybrid Cloud Lab

Microsoft Azure, Amazon Web Services ve şirket içi (On-Premises) Active Directory ortamını bir araya getiren pratik bir hibrit bulut laboratuvarı.

Projenin amacı, bulut platformlarını mevcut bir On-Premises altyapıya bağlamak ve pratik hibrit bağlantı, hibrit kimlik ve ortamlar arası iletişim senaryolarını göstermektir.

📌 Proje Genel Bakışı

Proje aşağıdaki ortam ve teknolojileri içermektedir:

Microsoft Azure
Amazon Web Services
On-Premises Active Directory
Tailscale
Hibrit Kimlik
DNS
Ağ Bağlantısı

Üç ortam da hibrit ağ üzerinden birbiriyle iletişim kurabilmektedir.

Ortam içerisindeki en önemli hibrit entegrasyon, On-Premises Active Directory ile Microsoft Azure arasındadır.

AWS ortamı ayrı bir bulut altyapısı olarak tutulurken, Tailscale üzerinden genel hibrit ağa dahil olmaktadır.

🏗️ Mimari

Mimari üç ana ortamdan oluşmaktadır:

☁️ Microsoft Azure
☁️ Amazon Web Services
🪟 On-Premises Active Directory

Üç ortam da farklı altyapılar arasında ağ bağlantısı sağlayan Tailscale üzerinden birbirine bağlanmaktadır.

Birincil hibrit kimlik bağlantısı, On-Premises Active Directory ile Azure arasında Azure AD Connect üzerinden oluşturulmuştur.

1. 🔗 Hibrit Bağlantı — Tailscale

Tailscale, On-Premises, Azure ve AWS ortamları arasındaki ağ bağlantısı katmanını sağlar.

Her ortam arasında ayrı VPN bağlantıları oluşturmak yerine Tailscale, farklı altyapılardaki sistemlerin birbiriyle iletişim kurmasını sağlayan ortak bir özel ağ oluşturur.

Bağlantı
                    HİBRİT AĞ
                         │
                  ┌──────▼──────┐
                  │  Tailscale  │
                  │ Özel VPN Ağı│
                  └──────┬──────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
   ON-PREMISES        AZURE            AWS
   Active Directory   VNet             VPC
   Windows Server     Azure VM         EC2

Tailscale ağ bağlantısı katmanı olarak kullanılırken, gerçek servisler ve kimlikler kendi platformları tarafından yönetilmektedir.

Bu yapı, üç farklı ortamdaki sistemlerin özel ağ bağlantısı üzerinden iletişim kurmasını sağlar.

Kapsanan Konular
Özel ağ bağlantısı
Ortamlar arası iletişim
On-Premises → Azure bağlantısı
On-Premises → AWS bağlantısı
Azure → AWS bağlantısı
Tailscale subnet routing
Hibrit ağ iletişimi

Örneğin, On-Premises Windows Server makinemiz olan HL-DC01 üzerinden AWS üzerindeki web01 sanal makinesine bağlanabiliriz.

📸 Ekran Görüntüsü — Tailscale Bağlantısı

2. 🪟🔗☁️ On-Premises Active Directory ↔ Azure

Bu proje içerisindeki birincil hibrit entegrasyondur.

On-Premises Windows Server ortamı Active Directory altyapısını barındırırken, Microsoft Azure bulut kimliği ve altyapı bileşenlerini sağlamaktadır.

İki ortam arasında:

Tailscale üzerinden ağ bağlantısı
Azure AD Connect üzerinden kimlik senkronizasyonu

bulunmaktadır.

Bu yapı, On-Premises Active Directory ortamında bulunan kullanıcıların Azure'a senkronize edilebildiği pratik bir hibrit kimlik ortamı oluşturur.

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

Azure ortamı şunları içermektedir:

Virtual Network
Subnetler
Windows Server
Private Endpoint
Private DNS
Managed Identity

Azure ortamı, On-Premises altyapıya Tailscale üzerinden bağlanmaktadır.

Azure ayrıca On-Premises Active Directory ortamıyla entegrasyon sayesinde hibrit kimlik mimarisine dahil olmaktadır.

📸 Ekran Görüntüsü — Azure Bağlantısı

4. ☁️ Amazon Web Services

AWS, hibrit bulut portföyündeki ikinci bulut platformudur.

AWS ortamı şunları içermektedir:

VPC
Public ve Private Subnetler
EC2
Security Groups
Application Load Balancer

AWS altyapısı ayrı bir bulut ortamı olarak tutulmakta ve Terraform ile yönetilmektedir.

AWS, ortak Tailscale ağı üzerinden On-Premises ve Azure ortamlarına bağlanmaktadır.

Bu sayede AWS altyapısı genel hibrit ağa dahil olurken, AWS Active Directory kimlik senkronizasyon mimarisinin bir parçası haline gelmemektedir.

📸 Ekran Görüntüsü — AWS Bağlantısı

5. 🪟 On-Premises Active Directory

On-Premises ortamı Windows Server üzerinde oluşturulmuştur ve kuruluşun merkezi kimlik ve Windows altyapı servislerini sağlamaktadır.

Ortam şunları içermektedir:

Active Directory Domain Services
DNS
DHCP
Group Policy
Dosya Paylaşımı
Windows istemcileri

Active Directory ortamı Azure AD Connect kullanılarak Azure ile entegre edilmiştir.

Kullanıcı kimlikleri On-Premises Active Directory ile Azure arasında senkronize edilmektedir.

On-Premises ortamı ayrıca Tailscale üzerinden hibrit ağa dahil olmaktadır.

6. 🌐 Hibrit İletişim

Üç ortam Tailscale ağı üzerinden iletişim kurmaktadır:

                 ┌─────────────────────┐
                 │      TAILSCALE      │
                 │ Hibrit Bağlantı     │
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
   │ Hibrit Kimlik   │
   └─────────────────┘

Buradaki önemli ayrım şudur:

Tailscale = Ağ Bağlantısı

Azure AD Connect = Hibrit Kimlik

Tailscale ağ bağlantısını sağlarken, Azure AD Connect kimlik senkronizasyonunu sağlamaktadır.

Bu ayrım, aynı ortam içerisinde hem hibrit ağ hem de hibrit kimlik mimarisinin gösterilmesini sağlar.

📌 Hibrit Lab Odak Noktası

Bu proje On-Premises Active Directory, Microsoft Azure ve AWS ortamlarını birbirine bağlayan pratik bir hibrit altyapıyı göstermektedir.

Ana hibrit entegrasyon On-Premises Active Directory ile Azure arasındadır ve Azure AD Connect kimlik senkronizasyonunu sağlamaktadır.

Ağ katmanında ise Tailscale üç ortamı birbirine bağlamakta, böylece On-Premises, Azure ve AWS sistemlerinin hibrit altyapı üzerinden iletişim kurmasını sağlamaktadır.

Proje bu nedenle aşağıdaki konuları göstermektedir:

Hibrit ağ
Hibrit kimlik
Active Directory'nin Azure ile entegrasyonu
Azure AD Connect
Cross-cloud bağlantı
On-Premises → Cloud iletişimi
Azure → AWS iletişimi
AWS → On-Premises iletişimi
Tailscale tabanlı özel ağ bağlantısı
