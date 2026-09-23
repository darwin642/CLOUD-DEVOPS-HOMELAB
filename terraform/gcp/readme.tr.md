# GCP Terraform Uygulaması

## Genel Bakış

Bu bölüm, mevcut bir **Google Cloud Platform (GCP)** ortamının Infrastructure as Code (IaC) yaklaşımıyla **Terraform kullanılarak yönetilmesini** belgelemektedir.

Geleneksel Terraform kurulumlarında altyapı tamamen Terraform yapılandırmasından oluşturulurken, bu uygulamada odak noktası önceden mevcut olan GCP altyapısının Terraform'a import edilmesi, Terraform state ile gerçek altyapının senkronize edilmesi, configuration drift durumlarının tespit edilmesi ve Terraform yapılandırmasının mevcut kaynaklarla uyumlu hâle getirilmesidir.

Ortam; network, compute instance'ları, managed instance group, load balancing, autoscaling, Cloud Storage, IAM, private DNS, monitoring ve backup kaynaklarını içermektedir.

Bu uygulamanın nihai amacı Terraform'un mevcut altyapıyı doğru şekilde temsil etmesini ve:

```text
terraform plan
```

komutunun:

```text
No changes
```

sonucunu vermesini sağlamaktır.

Bu sonuç Terraform yapılandırmasının ve mevcut GCP altyapısının senkronize olduğunu gösterir.

---

# 1. Provider Yapılandırması ve Değişkenler

Google Cloud provider, mevcut GCP projesindeki kaynakları yönetmek için yapılandırılmıştır.

### Provider Yapılandırması

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

Ortam aşağıdaki yapılandırmayı kullanmaktadır:

| Ayar            | Değer                            |
| --------------- | -------------------------------- |
| Cloud Provider  | Google Cloud Platform            |
| Project         | `project-aed44365-ff0a-48b4-b75` |
| Region          | `europe-west3`                   |
| Zone            | `europe-west3-a`                 |
| Google Provider | `~> 7.0`                         |
| Terraform       | `1.15.8`                         |

### Kod Açıklaması

* `required_providers`, Terraform tarafından kullanılacak Google provider'ını tanımlar.
* `project`, altyapının bulunduğu GCP projesini belirtir.
* `region`, temel bölgesel konumu tanımlar.
* `zone`, Compute Engine instance'larının kullanıldığı zone'u belirtir.
* `~> 7.0`, Google provider'ın 7.x sürüm serisinde kalmasını sağlar.

---

# 2. Mevcut Altyapı ve Terraform Import

GCP ortamı Terraform yönetimi başlamadan önce zaten oluşturulmuş durumdaydı.

Altyapıyı yeniden oluşturmak yerine mevcut kaynaklar Terraform state'e import edilmiştir.

Genel işlem akışı:

```text
Mevcut GCP Altyapısı
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
Yapılandırma Uyumluluğu
          │
          ▼
    terraform plan
          │
          ▼
      No changes
```

Bu yaklaşım Terraform'un önceden oluşturulmuş altyapıyı yönetmesini sağlar.

### Terraform Import

Kaynaklar aşağıdakine benzer komutlarla import edilmiştir:

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

Aynı işlem network, load balancing, storage, IAM, monitoring, DNS, scaling ve backup kaynaklarına da uygulanmıştır.

### Kod Açıklaması

Terraform import iki temel işlem gerçekleştirir:

* Mevcut cloud kaynağını bir Terraform resource address ile ilişkilendirir.
* Kaynak hakkındaki bilgileri Terraform state içine kaydeder.

Import işlemi Terraform configuration'ını otomatik olarak oluşturmaz.

Configuration'ın ayrıca yazılması ve gerçek altyapıyı doğru şekilde temsil etmesi gerekir.

---

# 3. VPC ve Network

GCP ortamı aşağıdaki VPC'yi kullanmaktadır:

```text
lab_vpc
```

Terraform tarafından yönetilen yapı:

```hcl
resource "google_compute_network" "lab_vpc" {
  name                    = "..."
  auto_create_subnetworks = false
}
```

VPC, subnet'lerin ve bölgesel yapılandırmanın açıkça kontrol edilebilmesi için custom subnet mode kullanmaktadır.

### Network Yapısı

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
      │ public_subnet │     │ private_subnet│
      └───────────────┘     └───────────────┘
              │                     │
         WEB01 / WEB02            APP01
```

Custom VPC, ortamın diğer bileşenleri için temel network katmanını oluşturur.

---

# 4. Subnet Mimarisi

Terraform tarafından iki regional subnet yönetilmektedir:

* `public_subnet`
* `private_subnet`

Her iki subnet de:

```text
europe-west3
```

region'ında bulunmaktadır.

Private Google Access etkin durumdadır.

```hcl
resource "google_compute_subnetwork" "public_subnet" {
  name                     = "..."
  region                   = var.region
  network                  = google_compute_network.lab_vpc.id
  private_ip_google_access = true
}
```

Aynı yapılandırma private subnet için de kullanılmaktadır.

### Private Google Access

Private Google Access, external IP adresine sahip olmayan instance'ların desteklenen Google API ve servislerine Google altyapısı üzerinden erişmesini sağlar.

Bu özellikle private workload'ların public IP kullanmadan Cloud Storage gibi servislere erişebilmesi açısından önemlidir.

---

# 5. Firewall ve Network Güvenliği

Terraform ile farklı bileşenler arasındaki iletişimi kontrol etmek için çeşitli firewall kuralları yönetilmektedir.

| Firewall Rule      | Amaç                          |
| ------------------ | ----------------------------- |
| `allow_http`       | Web servislerine HTTP erişimi |
| `allow_iap_ssh`    | IAP üzerinden SSH erişimi     |
| `allow_web_to_app` | Web-to-application iletişimi  |
| `allow_app_5000`   | Application port 5000 trafiği |
| `app2_http_ns`     | Application HTTP trafiği      |

### Web-to-Application İletişimi

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

`allow_web_to_app` firewall kuralı web ve application katmanları arasındaki gerekli iletişimi kontrol eder.

Bu yapı, tüm workload'lar arasında sınırsız iletişim yerine network segmentation yaklaşımını göstermektedir.

---

# 6. Compute Instance'ları

Ortam üç temel Compute Engine instance içermektedir:

| Instance | Rol                  |
| -------- | -------------------- |
| `web01`  | Web workload         |
| `web02`  | Web workload         |
| `app01`  | Application workload |

Terraform her instance'ı ayrı bir resource olarak yönetmektedir.

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

### Web Katmanı

WEB01 ve WEB02 web workload'unu sağlamaktadır.

Gelen trafik Google Cloud Load Balancer üzerinden bu instance'lara dağıtılmaktadır.

### Application Katmanı

APP01 application workload'unu sağlamaktadır.

Private mimarinin içerisinde bulunur ve doğrudan Internet'e açılmak yerine web katmanı tarafından erişilir.

---

# 7. Instance Template

Terraform tarafından regional bir Compute Engine instance template yönetilmektedir:

```text
google_compute_region_instance_template.web_template
```

Instance template, Managed Instance Group tarafından oluşturulan web instance'ları için tekrar kullanılabilir bir yapılandırma sağlar.

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

Bu yapı yeni instance'ların tutarlı bir yapılandırmayla oluşturulmasını sağlar.

---

# 8. Managed Instance Group

Ortamda aşağıdaki Managed Instance Group bulunmaktadır:

```text
web_mig
```

Terraform tarafından yönetilen temel yapı:

```hcl
resource "google_compute_region_instance_group_manager" "web_mig" {
  name = "..."

  target_size = 2
}
```

Mevcut target size:

```text
2 instances
```

Managed Instance Group, instance template'e göre birden fazla instance'ın merkezi olarak yönetilmesini sağlar.

### Faydaları

MIG aşağıdaki özellikleri sağlar:

* Tutarlı instance yapılandırması
* Merkezi instance yönetimi
* Autoscaling entegrasyonu
* Web katmanı için daha iyi availability
* Instance replacement desteği

---

# 9. Autoscaling

Web Managed Instance Group için autoscaling yapılandırılmıştır.

Terraform tarafından:

```text
google_compute_autoscaler.web_mig
```

yönetilmektedir.

Autoscaler, tanımlanan scaling politikasına göre Managed Instance Group içerisindeki instance sayısını değiştirebilir.

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

Bu yapı web katmanı için otomatik ölçeklendirme mekanizması sağlar.

---

# 10. Load Balancing

GCP ortamında global bir HTTP Load Balancer bulunmaktadır.

Terraform aşağıdaki bileşenleri yönetmektedir:

```text
google_compute_health_check.web_health
google_compute_backend_service.web_backend
google_compute_url_map.web_lb
google_compute_target_http_proxy.web_lb
google_compute_global_forwarding_rule.web_lb
```

### Load Balancer Mimarisi

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

Global forwarding rule gelen trafiği kabul eder ve load balancing bileşenleri üzerinden backend service'e iletir.

---

# 11. Health Check

Backend service aşağıdaki Google Cloud health check'i kullanmaktadır:

```text
web_health
```

Health check web backend'lerinin kullanılabilirliğini kontrol eder.

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

Bu yapı load balancing trafiğinin sağlıklı backend'lere yönlendirilmesine yardımcı olur.

---

# 12. Web-to-Application İletişimi

Web ve application katmanları VPC içerisinde mantıksal olarak ayrılmıştır.

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

Application workload'un doğrudan Internet'e açılması gerekmemektedir.

İletişim bunun yerine web ve application katmanları arasındaki firewall kurallarıyla kontrol edilmektedir.

Bu yapı temel bir multi-tier application mimarisini göstermektedir.

---

# 13. Cloud Storage

Ortamda Terraform tarafından yönetilen bir Google Cloud Storage bucket bulunmaktadır.

Bucket:

```text
gcp-lab-storage-20260920
```

Bucket aşağıdaki özelliklere sahiptir:

* Standard storage class
* Europe-West3 location
* Uniform bucket-level access
* Public access prevention
* Soft delete
* Lifecycle management

### Lifecycle Management

Object'ler yaşlarına göre farklı storage class'lara taşınmaktadır.

| Object Yaşı | Storage Class |
| ----------- | ------------- |
| 30 gün      | Nearline      |
| 60 gün      | Coldline      |
| 90 gün      | Archive       |

```text
STANDARD
   │
   │ 30 gün
   ▼
NEARLINE
   │
   │ 60 gün
   ▼
COLDLINE
   │
   │ 90 gün
   ▼
ARCHIVE
```

Bu yapı otomatik storage lifecycle management kullanımını göstermektedir.

### Bucket Güvenliği

Public access prevention etkin durumdadır.

Uniform bucket-level access ise IAM tabanlı erişim yönetimini basitleştirir.

---

# 14. Cloud Storage IAM

Terraform bucket seviyesindeki IAM izinlerini aşağıdaki resource üzerinden yönetmektedir:

```text
google_storage_bucket_iam_binding.lab_object_viewer
```

Kullanılan rol:

```text
roles/storage.objectViewer
```

Erişim verilen kimlikler:

* GCP VM service account
* Yapılandırılmış kullanıcı hesabı

Bu yapı gereksiz yönetici yetkileri vermeden object okuma erişimi sağlamaktadır.

---

# 15. Service Account ve IAM

Ortamda özel bir service account bulunmaktadır:

```text
gcp-lab-vm
```

Terraform tarafından yönetilmektedir:

```hcl
resource "google_service_account" "vm_service_account" {
  account_id   = "gcp-lab-vm"
  display_name = "GCP Lab VM Service Account"
}
```

Service account gerekli Cloud Storage izinlerine de sahiptir.

Bu yapı geniş project-level izinler yerine identity-based access yaklaşımını göstermektedir.

---

# 16. Private DNS

Ortamda aşağıdaki private Cloud DNS managed zone bulunmaktadır:

```text
gcp-private-zone
```

DNS suffix:

```text
gcp.internal.
```

Zone private visibility ile yapılandırılmıştır.

Terraform tarafından:

```text
google_dns_managed_zone.gcp_private_zone
google_dns_record_set.web01
```

yönetilmektedir.

WEB01 kaydı:

```text
web01.gcp.internal.
```

şeklindedir ve WEB01'in private IP adresine çözülmektedir.

```text
web01.gcp.internal.
          │
          ▼
      Private DNS
          │
          ▼
         WEB01
```

Bu yapı DNS kaydının public olarak yayınlanmasına gerek kalmadan internal name resolution sağlar.

---

# 17. Monitoring ve Alerting

Web workload'unu izlemek için Cloud Monitoring kullanılmaktadır.

Terraform tarafından:

```text
google_monitoring_alert_policy.web01_80_cpu
```

yönetilmektedir.

Alert policy WEB01'in CPU kullanımını izler.

| Ayar          | Değer                        |
| ------------- | ---------------------------- |
| Policy        | `web01_80_cpu`               |
| Severity      | WARNING                      |
| Metric        | GCE instance CPU utilization |
| Threshold     | 80%                          |
| Alignment     | 60 seconds                   |
| Trigger Count | 1                            |
| Notification  | Email                        |

CPU kullanımı tanımlanan threshold değerini aştığında yapılandırılmış notification channel üzerinden e-posta bildirimi gönderilir.

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

Ortamda VM protection için Google Cloud Backup and DR kullanılmaktadır.

Terraform tarafından aşağıdaki backup vault yönetilmektedir:

```text
gcp-lab-vault
```

Konumu:

```text
europe-west3
```

Vault organization-level access restriction ve minimum retention period kullanmaktadır.

Vault, korunan Compute Engine backup'larının saklandığı konumu sağlar.

---

# 19. Backup Plan

Aşağıdaki backup plan APP01 için yapılandırılmıştır:

```text
gcp-app01-backup
```

### Backup Yapılandırması

| Ayar          | Değer                   |
| ------------- | ----------------------- |
| Location      | `europe-west3`          |
| Resource Type | Compute Engine Instance |
| Frequency     | Daily                   |
| Time Zone     | Europe/Berlin           |
| Backup Window | 00:00–06:00             |
| Retention     | 14 days                 |
| Backup Vault  | `gcp-lab-vault`         |

Mimari:

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

Bu yapı APP01 için zamanlanmış backup koruması sağlar.

---

# 20. Backup Plan Association

Backup plan APP01 ile aşağıdaki Terraform resource üzerinden ilişkilendirilmiştir:

```text
google_backup_dr_backup_plan_association.app01
```

Association aktif durumdadır ve kaydedilen son backup başarıyla tamamlanmıştır.

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

Bu yapı Compute Engine workload'unu backup policy ve vault ile ilişkilendirir.

---

# 21. Terraform State

Terraform state, Terraform configuration ile gerçek GCP altyapısı arasındaki bağlantıyı oluşturur.

Mevcut Terraform state, import edilmiş altyapı kaynaklarını içermektedir.

State içerisinde:

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

kaynakları bulunmaktadır.

State şu komutla incelenebilir:

```powershell
terraform state list
```

Mevcut environment toplam **30 Terraform-managed resource** içermektedir.

---

# 22. Terraform Drift Detection

Import işleminden sonra Terraform configuration ile gerçek altyapı karşılaştırılmıştır.

İşlem akışı:

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

Bu süreçte Terraform mevcut altyapı ile başlangıç configuration'ı arasında farklılıklar tespit etmiştir.

Örneğin Managed Instance Group target size değeri kontrol edilmiştir.

Mevcut ortam:

```text
target_size = 2
```

olarak yapılandırılmıştır.

Terraform configuration buna göre hizalanmıştır.

Bu işlem Terraform'un yalnızca provisioning için değil, infrastructure drift tespiti ve reconciliation için de kullanılabileceğini göstermektedir.

---

# 23. Backup Association State Yönetimi

Import işlemi sırasında Backup Plan Association için bir provider/state synchronization problemi gözlemlenmiştir.

GCP API Compute Engine resource bilgisini doğru şekilde döndürürken, import edilen Terraform state aynı `resource` değerini state içerisinde korumamıştır.

Gerekli configuration korunmuştur:

```hcl
resource = google_compute_instance.app01.id
```

Ardından aşağıdaki lifecycle configuration kullanılmıştır:

```hcl
lifecycle {
  ignore_changes = [resource]
}
```

Bu yapı, gerekli configuration'ın korunmasını sağlarken provider tarafından gözlemlenen state farkının sürekli bir plan değişikliği oluşturmasını engellemiştir.

Bu değişiklikten sonra resource `terraform plan` sırasında sürekli bir difference üretmemiştir.

Bu durum gerçek backup configuration'ında yapılan bir değişiklikten ziyade gözlemlenen bir provider/state synchronization davranışı olarak değerlendirilmiştir.

---

# 24. Terraform Validation Workflow

Son doğrulama sürecinde aşağıdaki komutlar kullanılmıştır:

```powershell
terraform fmt
```

```powershell
terraform validate
```

```powershell
terraform plan
```

En önemli sonuç:

```text
No changes
```

Bu sonuç Terraform'un mevcut configuration'ın Terraform state ve GCP altyapısıyla uyumlu olduğunu tespit ettiğini gösterir.

Final workflow:

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

Final synchronization durumunda altyapının yeniden oluşturulmasına gerek yoktur.

---

# 25. Infrastructure as Code Model

Bu GCP uygulaması mevcut cloud altyapısının Infrastructure as Code yaklaşımıyla yönetilmesini göstermektedir.

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

Buradaki temel konsept Terraform'un yalnızca yeni infrastructure oluşturmakla sınırlı olmamasıdır.

Terraform aynı zamanda mevcut infrastructure'ı kod tabanlı yönetim altına almak için de kullanılabilir.

Final configuration mevcut GCP environment'ını tekrar üretilebilir bir kod temsili hâline getirirken mevcut deployed resource'ları korumaktadır.

---

# 26. Yönetilen GCP Kaynakları

Final Terraform state aşağıdaki kaynak kategorilerini içermektedir:

| Kategori            | Yönetilen Kaynaklar                                                 |
| ------------------- | ------------------------------------------------------------------- |
| Networking          | VPC, Public Subnet, Private Subnet                                  |
| Firewall            | HTTP, IAP SSH, Web-to-App, Application rules                        |
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

# 27. Final Architecture

GCP ortamının tamamı aşağıdaki şekilde temsil edilebilir:

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
        │  ┌────────────────┐ ┌───────────────┐ │
        │  │ public_subnet  │ │private_subnet │ │
        │  │ WEB01 / WEB02  │ │     APP01     │ │
        │  └────────────────┘ └───────────────┘ │
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

Bu Terraform uygulaması mevcut bir GCP ortamının Infrastructure as Code yaklaşımıyla yönetilmesini göstermektedir.

Lab aşağıdaki konuları kapsamaktadır:

* Mevcut infrastructure import işlemi
* Terraform state yönetimi
* VPC ve subnet yapılandırması
* Firewall kuralları
* Compute Engine
* Managed Instance Groups
* Autoscaling
* Global HTTP Load Balancing
* Cloud Storage lifecycle management
* IAM ve service accounts
* Private Cloud DNS
* Private Google Access
* Cloud Monitoring
* Backup ve Disaster Recovery
* Infrastructure drift detection
* Provider/state synchronization yönetimi
* Terraform validation

Projenin final durumu:

```powershell
terraform plan
```

sonucunda:

```text
No changes
```

vermektedir.

Bu sonuç Terraform configuration'ının mevcut GCP infrastructure ile senkronize olduğunu ve ortamın Terraform tarafından doğru şekilde temsil edilip yönetilebildiğini göstermektedir.
