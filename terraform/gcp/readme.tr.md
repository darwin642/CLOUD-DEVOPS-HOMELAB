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
             ┌─────
```
