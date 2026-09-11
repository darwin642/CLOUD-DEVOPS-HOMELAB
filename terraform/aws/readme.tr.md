# AWS Terraform Uygulaması

## Genel Bakış

Bu sayfa, lab ortamındaki AWS altyapısını oluşturmak ve yönetmek için kullanılan Terraform uygulamasını dokümante eder.

Yapılandırma; ağ, güvenlik, EC2 sunucuları, Application Load Balancer, IAM, monitoring, Systems Manager bağlantısı ve S3 lifecycle yönetimini kapsar.

Terraform sayesinde bu kaynaklar AWS Management Console üzerinden manuel olarak oluşturulmak yerine kod olarak tanımlanır ve yönetilir.

---

# Mimari

```text
                              Terraform
                                  │
                                  │
                           Amazon Web Services
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
                   VPC                     IAM / Monitoring
              10.0.0.0/16                         │
                    │                    ┌────────┼────────┐
          ┌─────────┼─────────┐          │        │        │
          │         │         │         IAM   CloudWatch  SNS
       Public 1  Public 2   Private
          │         │         │
       WEB01     WEB02     APP01
          │         │         │
          └────┬────┘         │
               │              │
        Application LB        │
               │              │
          HTTP :80            │
               │              │
          Web Servers ────────┘
             │
             │ HTTP :80 / :8080
             ▼
          APP01 Backend
```

Mimari, web katmanı için iki farklı Availability Zone'da bulunan iki public subnet ve backend için private bir subnet kullanır.

Application Load Balancer, HTTP trafiğini `WEB01` ve `WEB02` arasında dağıtır.

Web sunucuları ise gelen istekleri private subnet içerisindeki `APP01` backend sunucusuna reverse proxy üzerinden iletir.

---

# Proje Yapısı

```text
aws/
│
├── main.tf
├── variables.tf
├── terraform.tfvars
└── terraform.tfstate
```

## Dosyaların Görevleri

| Dosya               | Görevi                                                                                                 |
| ------------------- | ------------------------------------------------------------------------------------------------------ |
| `main.tf`           | AWS altyapısı, networking, security, EC2, ALB, IAM, monitoring, SSM endpoint'leri ve S3 yapılandırması |
| `variables.tf`      | Tekrar kullanılabilir Terraform değişkenlerini tanımlar                                                |
| `terraform.tfvars`  | Ortama özel değişken değerlerini sağlar                                                                |
| `terraform.tfstate` | Terraform tarafından yönetilen AWS altyapısının mevcut durumunu temsil eder                            |

> **Not:** Terraform state dosyası bu dokümantasyona dahil edilmemiştir. State dosyaları hassas altyapı bilgileri içerebilir.

---

# 1. Provider Yapılandırması ve Değişkenler

AWS provider, Terraform'un AWS ile nasıl iletişim kuracağını tanımlar.

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

## Kod Açıklaması

* `terraform {}` Terraform seviyesindeki yapılandırmayı tanımlar.
* `required_providers`, gerekli provider'ları belirtir.
* `aws`, kullanılacak provider'ın adıdır.
* `source = "hashicorp/aws"`, resmi AWS provider'ının kullanılacağını belirtir.
* `provider "aws"`, AWS provider'ının yapılandırmasını oluşturur.
* `region = var.aws_region`, kaynakların hangi AWS region içerisinde oluşturulacağını belirler.
* Region doğrudan kodun içine yazılmak yerine variable üzerinden alınır.

Bu yapı sayesinde aynı Terraform kodu farklı bir AWS region'ında da kullanılabilir.

---

## Değişkenler

Ortamda kullanılan temel değerler Terraform variable'ları ile tanımlanır.

```hcl
variable "aws_region" {
  description = "AWS region for the lab"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "public2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "private_cidr" {
  description = "CIDR block for private subnet"
  type        = string
}
```

## Kod Açıklaması

Her `variable` bloğu Terraform içerisinde tekrar kullanılabilir bir input oluşturur.

Örneğin:

```hcl
vpc_cidr = var.vpc_cidr
```

şeklinde kullanıldığında VPC'nin CIDR değeri doğrudan resource içerisine hardcode edilmez.

Bu yaklaşım aynı Terraform kodunun farklı ortamlar için kullanılmasını kolaylaştırır.

---

## Ortam Değerleri

Lab ortamında kullanılan temel değerler:

```hcl
aws_region          = "eu-north-1"
vpc_cidr            = "10.0.0.0/16"
public1_cidr        = "10.0.1.0/24"
public2_cidr        = "10.0.2.0/24"
private_cidr        = "10.0.3.0/24"
availability_zone_1 = "eu-north-1a"
availability_zone_2 = "eu-north-1b"
instance_type       = "t3.micro"
```

### Kod Açıklaması

* `aws_region`, AWS deployment region'ını belirler.
* `vpc_cidr`, VPC'nin IP adres alanını belirler.
* `public1_cidr` ve `public2_cidr`, web subnet'lerinin IP aralıklarını belirler.
* `private_cidr`, backend subnet'inin IP aralığını belirler.
* `availability_zone_1` ve `availability_zone_2`, kaynakların hangi Availability Zone'larda çalışacağını belirler.
* `instance_type`, EC2 instance boyutunu belirler.

---

# 2. Local Değerler ve Ortak Tag'ler

Kaynaklarda tekrar kullanılan değerler `locals` ile merkezi olarak tanımlanır.

```hcl
locals {
  project     = "aws-lab"
  environment = "dev"

  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}
```

## Kod Açıklaması

* `locals`, Terraform içerisinde tekrar kullanılacak değerleri tanımlar.
* `local.project`, proje adını tutar.
* `local.environment`, ortamın adını belirtir.
* `common_tags`, tüm AWS kaynaklarında kullanılabilecek ortak tag'leri oluşturur.
* `local.project` ve `local.environment`, yukarıdaki local değerlerine referans verir.

Kaynaklarda daha sonra:

```hcl
tags = local.common_tags
```

kullanılarak aynı tag yapısı tekrar tekrar yazılmadan uygulanabilir.

Bu sayede kaynaklar arasında tutarlı bir naming/tagging standardı oluşturulur.

---

# 3. VPC ve Network

Ana VPC, AWS ortamının izole network sınırını oluşturur.

```hcl
resource "aws_vpc" "benbenim" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.common_tags
}
```

## Kod Açıklaması

* `resource "aws_vpc"`, Terraform'a bir AWS VPC oluşturmasını söyler.
* `"benbenim"`, Terraform içerisinde kullanılan resource adıdır.
* `cidr_block = var.vpc_cidr`, VPC'nin IP adres alanını variable'dan alır.
* `enable_dns_support = true`, VPC içerisinde DNS çözümlemesini etkinleştirir.
* `enable_dns_hostnames = true`, VPC içerisindeki instance'ların DNS hostname kullanabilmesini sağlar.
* `tags = local.common_tags`, ortak tag yapısını VPC'ye uygular.

Başka kaynaklar bu VPC'ye:

```hcl
aws_vpc.benbenim.id
```

şeklinde referans verebilir.

Terraform böylece kaynaklar arasındaki dependency ilişkisini otomatik olarak oluşturur.

---

# 4. Subnet Mimarisi

Ortam üç subnet içerir:

| Subnet   | CIDR          | Availability Zone | Amaç  |
| -------- | ------------- | ----------------- | ----- |
| Public 1 | `10.0.1.0/24` | `eu-north-1a`     | WEB01 |
| Public 2 | `10.0.2.0/24` | `eu-north-1b`     | WEB02 |
| Private  | `10.0.3.0/24` | `eu-north-1a`     | APP01 |

İki web sunucusu farklı Availability Zone'lara dağıtılmıştır.

```hcl
resource "aws_subnet" "public1_subnet" {
  vpc_id            = aws_vpc.benbenim.id
  cidr_block        = var.public1_cidr
  availability_zone = "eu-north-1a"
  tags              = local.common_tags
}

resource "aws_subnet" "public2_subnet" {
  vpc_id            = aws_vpc.benbenim.id
  cidr_block        = var.public2_cidr
  availability_zone = "eu-north-1b"
  tags              = local.common_tags
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.benbenim.id
  cidr_block        = var.private_cidr
  availability_zone = "eu-north-1a"
  tags              = local.common_tags
}
```

## Kod Açıklaması

Her `aws_subnet` resource'u VPC içerisinde bir subnet oluşturur.

Örneğin:

```hcl
vpc_id = aws_vpc.benbenim.id
```

subnet'i daha önce oluşturulan VPC'ye bağlar.

```hcl
cidr_block = var.public1_cidr
```

subnet'in IP adres aralığını belirler.

```hcl
availability_zone = "eu-north-1a"
```

subnet'in hangi Availability Zone içerisinde bulunacağını belirler.

`WEB01` ve `WEB02` farklı Availability Zone'larda çalıştırıldığı için web katmanında Availability Zone seviyesinde temel redundancy sağlanır.

---

# 5. Internet Gateway

Internet Gateway, VPC ile internet arasında bağlantı sağlar.

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.benbenim.id

  tags = local.common_tags
}
```

## Kod Açıklaması

* `aws_internet_gateway`, Internet Gateway oluşturur.
* `vpc_id`, gateway'i lab VPC'sine bağlar.
* `tags`, ortak tag yapısını uygular.

Internet Gateway oluşturmak tek başına subnet'i public yapmaz.

Public subnet'in internete çıkabilmesi için route table içerisinde Internet Gateway'e yönlenen bir route bulunması gerekir.

---

# 6. Route Tables ve Routing

Public route table, internet trafiğini Internet Gateway'e gönderir.

```hcl
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
```

## Kod Açıklaması

* `route_table_id`, route'un hangi route table'a ekleneceğini belirtir.
* `destination_cidr_block = "0.0.0.0/0"`, eşleşen tüm IPv4 hedeflerini temsil eder.
* `gateway_id`, trafiğin gönderileceği Internet Gateway'i belirtir.

Network akışı:

```text
WEB01 / WEB02
      │
      ▼
Public Route Table
      │
      ▼
Internet Gateway
      │
      ▼
   Internet
```

İki public subnet de bu route table ile ilişkilendirilerek web katmanının internete erişmesi sağlanır.

---

# 7. Security Groups

Security Group'lar application katmanları arasındaki network erişimini kontrol eder.

Mimaride üç temel Security Group kullanılır:

* ALB Security Group
* Web Security Group
* Application Security Group

---

## ALB Security Group

Application Load Balancer internetten HTTP trafiği kabul eder.

```hcl
ingress {
  description = "HTTP from Internet"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

## Kod Açıklaması

Bu kural ALB'nin TCP/80 üzerinden HTTP trafiği kabul etmesini sağlar.

* `from_port = 80`, başlangıç portudur.
* `to_port = 80`, bitiş portudur.
* `protocol = "tcp"`, yalnızca TCP trafiğini kabul eder.
* `0.0.0.0/0`, tüm IPv4 kaynaklarından gelen trafiği temsil eder.

Böylece ALB internet-facing giriş noktası olarak görev yapar.

---

## Web Security Group

Web sunucuları HTTP trafiğini doğrudan internetten değil, yalnızca ALB'den kabul eder.

```hcl
ingress {
  description     = "HTTP from ALB"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  security_groups = [aws_security_group.alb.id]
}
```

## Kod Açıklaması

Buradaki önemli bölüm:

```hcl
security_groups = [aws_security_group.alb.id]
```

Kaynak olarak IP adresi yerine ALB'nin Security Group'u kullanılır.

Böylece:

```text
Internet
   │
   ▼
   ALB
   │
   │ HTTP :80
   ▼
WEB01 / WEB02
```

şeklinde kontrollü bir trafik akışı oluşturulur.

Web sunucularına doğrudan internetten HTTP erişimi verilmesi yerine yalnızca ALB üzerinden erişim sağlanır.

---

## Application Security Group

APP01 private subnet içerisinde bulunur ve yalnızca web katmanından gelen uygulama trafiğini kabul eder.

```hcl
ingress {
  description     = "HTTP from Web Servers"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  security_groups = [aws_security_group.web.id]
}
```

## Kod Açıklaması

Buradaki:

```hcl
security_groups = [aws_security_group.web.id]
```

kuralı, port `80` üzerindeki erişimi Web Security Group'a sahip kaynaklarla sınırlar.

Internet'ten doğrudan APP01'e HTTP erişimi verilmez.

Katmanlı yapı:

```text
Internet
   │
   ▼
  ALB
   │
   │ HTTP :80
   ▼
WEB01 / WEB02
   │
   │ HTTP :80 / :8080
   ▼
 APP01
```

Bu yapı web katmanı ile application katmanını birbirinden ayırır.

---

# 8. EC2 Instances

EC2 kaynakları compute katmanını oluşturur.

```hcl
resource "aws_instance" "web01" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public1_subnet.id

  security_groups = [
    aws_security_group.web.id
  ]
}
```

## Kod Açıklaması

* `aws_instance`, EC2 instance oluşturur.
* `ami`, kullanılacak işletim sistemi image'ını belirler.
* `instance_type`, EC2 instance'ın compute kapasitesini belirler.
* `subnet_id`, instance'ın hangi subnet içerisinde bulunacağını belirler.
* `security_groups`, instance'a uygulanacak Security Group'u belirler.

`WEB01`, public subnet'e yerleştirilir.

`WEB02` aynı mantıkla oluşturulur ancak ikinci public subnet'e yerleştirilerek farklı Availability Zone'da çalışır.

`APP01` ise private subnet içerisinde bulunur ve public IP gerektirmez.

---

# 9. Application Load Balancer

Application Load Balancer, gelen HTTP trafiğini WEB01 ve WEB02 arasında dağıtır.

```hcl
resource "aws_lb" "main" {
  name               = "aws-lab-alb"
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public1_subnet.id,
    aws_subnet.public2_subnet.id
  ]

  security_groups = [
    aws_security_group.alb.id
  ]
}
```

## Kod Açıklaması

* `aws_lb`, Load Balancer oluşturur.
* `load_balancer_type = "application"`, Application Load Balancer oluşturulacağını belirtir.
* İki subnet'in verilmesi ALB'nin iki Availability Zone'da çalışmasını sağlar.
* `security_groups`, ALB'ye uygulanacak Security Group'u belirler.

Trafik akışı:

```text
                 Internet
                    │
                    ▼
             Application LB
              /          \
             /            \
          WEB01          WEB02
        eu-north-1a    eu-north-1b
```

---

# 10. Target Group

Target Group, ALB'nin hangi backend instance'larına trafik göndereceğini tanımlar.

```hcl
resource "aws_lb_target_group" "web" {
  name     = "aws-lab-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.benbenim.id
}
```

## Kod Açıklaması

* `aws_lb_target_group`, ALB'nin backend hedef grubunu oluşturur.
* `port = 80`, backend sunucularının HTTP üzerinden hangi porttan dinlediğini belirtir.
* `protocol = "HTTP"`, ALB ile backend arasındaki iletişim protokolünü belirler.
* `vpc_id`, target group'u lab VPC'sine bağlar.

WEB01 ve WEB02 bu target group içerisine eklenerek ALB'nin bu sunuculara trafik göndermesi sağlanır.

---

# 11. Web → Application İletişimi

Web sunucuları, private APP01 backend'ine reverse proxy görevi görerek istekleri iletir.

Trafik akışı:

```text
Client
  │
  │ HTTP :80
  ▼
 ALB
  │
  ▼
WEB01 / WEB02
  │
  │ HTTP :80 / :8080
  ▼
APP01
```

## Kod Mantığı

Terraform burada network ve Security Group seviyesinde gerekli erişimi sağlar.

Web sunucularında çalışan reverse-proxy yapılandırması ise gelen istekleri APP01'in private IP adresine yönlendirir.

Böylece APP01 public IP almadan web katmanından erişilebilir durumda kalır.

---

# 12. IAM

IAM kaynakları AWS kimliklerini ve yetkilerini Terraform üzerinden yönetmek için kullanılır.

```hcl
resource "aws_iam_user" "lab_user" {
  name = "lab-user"
}
```

## Kod Açıklaması

* `aws_iam_user`, bir IAM kullanıcısı oluşturur.
* `name`, AWS içerisindeki kullanıcı adını belirler.

Kullanıcının yetkileri ayrıca policy veya policy attachment kaynaklarıyla tanımlanabilir.

Bu sayede kullanıcı oluşturma ve authorization yapılandırması AWS Console yerine Infrastructure as Code olarak yönetilebilir.

---

# 13. CloudWatch Monitoring

CloudWatch metric alarm'ları altyapının izlenmesi için kullanılır.

```hcl
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
}
```

## Kod Açıklaması

* `aws_cloudwatch_metric_alarm`, CloudWatch alarmı oluşturur.
* `alarm_name`, alarmın adını belirler.
* `comparison_operator`, metric'in hangi koşula göre değerlendirileceğini belirler.
* `threshold = 80`, alarm için kullanılan eşik değeridir.

Metric belirlenen koşulu geçtiğinde CloudWatch alarm durumunu değiştirir.

Bu yapı altyapı monitoring ve operational visibility sağlar.

---

# 14. Systems Manager Bağlantısı

AWS Systems Manager, EC2 sunucularına doğrudan inbound SSH erişimi gerektirmeden yönetim bağlantısı sağlayabilir.

Private APP01 için mimari şu şekildedir:

```text
APP01
  │
  │ HTTPS :443
  ▼
VPC Endpoints
  │
  ├── SSM
  ├── SSMMessages
  └── EC2Messages
  │
  ▼
AWS Systems Manager
```

## Kod Mantığı

Terraform tarafında VPC endpoint'leri ve bunlara bağlı Security Group yapılandırılır.

Bu endpoint'ler private subnet içerisindeki kaynakların AWS Systems Manager servislerine private network üzerinden ulaşmasını sağlar.

Böylece APP01:

* Public IP olmadan çalışabilir.
* İnternete açık SSH portu gerektirmez.
* Systems Manager üzerinden yönetilebilir.

Bu yaklaşım private workload'lar için daha güvenli bir yönetim modeli sağlar.

---

# 15. S3 Lifecycle Yönetimi

S3 lifecycle configuration, bucket içerisindeki objelerin yaşam döngüsünü otomatik olarak yönetir.

```hcl
resource "aws_s3_bucket_lifecycle_configuration" "lab" {
  bucket = aws_s3_bucket.lab.id

  rule {
    id     = "cleanup"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}
```

## Kod Açıklaması

* `aws_s3_bucket_lifecycle_configuration`, S3 lifecycle yapılandırmasını oluşturur.
* `bucket`, kuralın uygulanacağı S3 bucket'ını belirler.
* `rule`, lifecycle kuralını tanımlar.
* `status = "Enabled"`, kuralı aktif hale getirir.
* `expiration`, objelerin ne zaman expire edileceğini belirler.
* `days = 30`, eşleşen objelerin 30 gün sonra silinmesini sağlar.

Bu sayede eski verilerin manuel olarak temizlenmesi yerine lifecycle işlemi otomatikleştirilir.

---

# 16. Terraform State

Terraform, yönettiği altyapının mevcut durumunu state dosyasında takip eder.

```text
Terraform Configuration
        │
        ▼
   terraform plan
        │
        ▼
Terraform State
        │
        ▼
  AWS Infrastructure
```

## Kod Mantığı

Terraform state sayesinde Terraform:

* Hangi kaynakların yönetildiğini bilir.
* Mevcut kaynakların durumunu takip eder.
* Configuration ile mevcut state arasındaki farkı hesaplar.
* Gerekli değişiklikleri `terraform plan` sırasında gösterir.

State dosyası hassas altyapı bilgileri içerebileceği için public repository'ye eklenmez.

---

# 17. Terraform Workflow

Altyapı standart Terraform workflow'u üzerinden yönetilir.

```bash
terraform init
terraform plan
terraform apply
```

## `terraform init`

Terraform çalışma dizinini başlatır ve gerekli provider'ları indirir.

## `terraform plan`

Terraform configuration ile mevcut state'i karşılaştırır ve AWS üzerinde hangi değişikliklerin yapılması gerektiğini gösterir.

Bu aşamada herhangi bir değişiklik uygulanmaz.

## `terraform apply`

Planlanan değişiklikleri AWS üzerinde uygular.

Lab altyapısı Terraform'a aktarıldıktan sonra configuration doğrulaması:

```bash
terraform plan
```

komutuyla gerçekleştirilmiştir.

Başarılı bir:

```text
No changes
```

sonucu, Terraform configuration ile mevcut Terraform state arasında uygulanması gereken bir değişiklik olmadığını gösterir.

---

# 18. Infrastructure as Code Modeli

Terraform mimarisi deklaratif bir model kullanır.

```text
Terraform Code
      │
      ▼
Terraform Provider
      │
      ▼
AWS API
      │
      ▼
AWS Infrastructure
```

Terraform'a **“şu komutları sırayla çalıştır”** demek yerine, istenen altyapının nasıl olması gerektiği tanımlanır.

Terraform daha sonra mevcut durum ile istenen durum arasındaki farkı hesaplar ve gerekli değişiklikleri AWS API üzerinden gerçekleştirir.

Bu yaklaşım:

* Tekrarlanabilir deployment
* Version-controlled infrastructure
* Tutarlı configuration
* Daha kolay infrastructure changes
* Daha az manuel configuration
* Infrastructure drift tespiti
* Reproducible environment

sağlar.
