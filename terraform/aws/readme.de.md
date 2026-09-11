# AWS Terraform Implementierung

## Überblick

Diese Seite dokumentiert die Terraform-Implementierung, die zur Bereitstellung und Verwaltung der AWS-Infrastruktur in der Lab-Umgebung verwendet wird.

Die Konfiguration umfasst Netzwerk, Sicherheit, EC2-Instanzen, Application Load Balancer, IAM, Monitoring, Systems Manager-Konnektivität und S3-Lifecycle-Management.

Terraform wird verwendet, um diese Ressourcen als Code zu definieren und zu verwalten, anstatt sie manuell über die AWS Management Console zu konfigurieren.

---

# 1. Provider-Konfiguration und Variablen

Der AWS Provider wird so konfiguriert, dass die in den Terraform-Variablen definierte Region verwendet wird.

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

## Code-Erklärung

* `terraform {}` definiert die Terraform-Konfiguration auf Terraform-Ebene.
* `required_providers` gibt an, welche Provider benötigt werden.
* `aws` identifiziert den AWS Provider.
* `source = "hashicorp/aws"` gibt an, dass der offizielle AWS Provider von HashiCorp verwendet wird.
* `provider "aws"` konfiguriert den AWS Provider.
* `region = var.aws_region` legt fest, in welcher AWS-Region die Ressourcen erstellt werden.
* Die Region wird über eine Variable angegeben, anstatt sie direkt im Code fest zu hinterlegen.

Dadurch kann dieselbe Terraform-Konfiguration auch in einer anderen AWS-Region verwendet werden, indem lediglich der Variablenwert geändert wird.

---

## Variablen

Die wichtigsten Umgebungsparameter werden als Terraform-Variablen definiert.

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

## Code-Erklärung

Jeder `variable`-Block erstellt einen wiederverwendbaren Input für Terraform.

Zum Beispiel:

```hcl
vpc_cidr = var.vpc_cidr
```

Dadurch wird der CIDR-Bereich der VPC nicht direkt im Resource-Block fest codiert.

Dieser Ansatz ermöglicht es, dieselbe Terraform-Konfiguration für verschiedene Umgebungen wiederzuverwenden.

---

## Aktuelle Lab-Werte

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

---

# 2. Local Values und gemeinsame Tags

Wiederverwendbare Werte werden mit `locals` zentral definiert.

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

## Code-Erklärung

* `locals` definiert wiederverwendbare Werte innerhalb von Terraform.
* `local.project` enthält den Projektnamen.
* `local.environment` definiert die Umgebung.
* `common_tags` enthält gemeinsame Tags für AWS-Ressourcen.
* `local.project` und `local.environment` referenzieren die zuvor definierten Local Values.

Diese Struktur kann später beispielsweise so verwendet werden:

```hcl
tags = local.common_tags
```

Dadurch muss dieselbe Tag-Konfiguration nicht für jede Ressource erneut geschrieben werden.

Das sorgt für eine konsistente Tagging-Struktur innerhalb der gesamten Umgebung.

---

# 3. VPC und Netzwerk

Die zentrale VPC bildet die isolierte Netzwerkgrenze der AWS-Umgebung.

```hcl
resource "aws_vpc" "benbenim" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.common_tags
}
```

## Code-Erklärung

* `resource "aws_vpc"` weist Terraform an, eine AWS VPC zu erstellen.
* `"benbenim"` ist der lokale Terraform-Name der Resource.
* `cidr_block = var.vpc_cidr` übernimmt den CIDR-Bereich aus einer Variable.
* `enable_dns_support = true` aktiviert die DNS-Unterstützung innerhalb der VPC.
* `enable_dns_hostnames = true` ermöglicht DNS-Hostnames für Ressourcen innerhalb der VPC.
* `tags = local.common_tags` weist der VPC die gemeinsamen Tags zu.

Andere Ressourcen können anschließend auf diese VPC verweisen:

```hcl
aws_vpc.benbenim.id
```

Terraform erkennt dadurch automatisch die Abhängigkeit zwischen den Ressourcen.

---

# 4. Subnet-Architektur

Die Umgebung besteht aus drei Subnetzen:

| Subnetz  | CIDR          | Availability Zone | Zweck |
| -------- | ------------- | ----------------- | ----- |
| Public 1 | `10.0.1.0/24` | `eu-north-1a`     | WEB01 |
| Public 2 | `10.0.2.0/24` | `eu-north-1b`     | WEB02 |
| Private  | `10.0.3.0/24` | `eu-north-1a`     | APP01 |

WEB01 und WEB02 befinden sich in unterschiedlichen Availability Zones.

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

## Code-Erklärung

Jede `aws_subnet`-Resource erstellt ein Subnetz innerhalb der VPC.

```hcl
vpc_id = aws_vpc.benbenim.id
```

verbindet das Subnetz mit der zuvor erstellten VPC.

```hcl
cidr_block = var.public1_cidr
```

definiert den IP-Adressbereich des Subnetzes.

```hcl
availability_zone = "eu-north-1a"
```

bestimmt, in welcher Availability Zone sich das Subnetz befindet.

WEB01 und WEB02 werden auf unterschiedliche Availability Zones verteilt, um eine grundlegende Redundanz auf Availability-Zone-Ebene zu erreichen.

---

# 5. Internet Gateway

Das Internet Gateway stellt die Verbindung zwischen der VPC und dem Internet her.

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.benbenim.id

  tags = local.common_tags
}
```

## Code-Erklärung

* `aws_internet_gateway` erstellt ein Internet Gateway.
* `vpc_id` verbindet das Gateway mit der Lab-VPC.
* `tags` weist die gemeinsamen Tags zu.

Ein Internet Gateway allein macht ein Subnetz noch nicht öffentlich.

Damit ein Public Subnet auf das Internet zugreifen kann, muss eine entsprechende Route über das Internet Gateway vorhanden sein.

---

# 6. Route Tables und Routing

Die Public Route Table leitet Internetverkehr an das Internet Gateway weiter.

```hcl
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
```

## Code-Erklärung

* `route_table_id` bestimmt, welcher Route Table die Route hinzugefügt wird.
* `destination_cidr_block = "0.0.0.0/0"` steht für alle IPv4-Ziele.
* `gateway_id` bestimmt das Gateway, an das der Datenverkehr weitergeleitet wird.

Datenfluss:

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

---

# 7. Security Groups

Security Groups kontrollieren den Netzwerkzugriff zwischen den verschiedenen Anwendungsebenen.

Die Architektur verwendet drei zentrale Security Groups:

* ALB Security Group
* Web Security Group
* Application Security Group

---

## ALB Security Group

Der Application Load Balancer akzeptiert HTTP-Traffic aus dem Internet.

```hcl
ingress {
  description = "HTTP from Internet"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

## Code-Erklärung

Diese Regel erlaubt TCP-Verkehr auf Port `80`.

* `from_port = 80` definiert den Startport.
* `to_port = 80` definiert den Endport.
* `protocol = "tcp"` erlaubt TCP-Verkehr.
* `0.0.0.0/0` erlaubt den Zugriff aus allen IPv4-Netzwerken.

Der ALB fungiert dadurch als öffentlicher Einstiegspunkt der Anwendung.

---

## Web Security Group

Die Webserver akzeptieren HTTP-Traffic nur vom Application Load Balancer.

```hcl
ingress {
  description = "HTTP from ALB"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_groups = [aws_security_group.alb.id]
}
```

## Code-Erklärung

Der wichtige Teil ist:

```hcl
security_groups = [aws_security_group.alb.id]
```

Hier wird nicht eine bestimmte IP-Adresse als Quelle verwendet, sondern die Security Group des ALB.

Datenfluss:

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

Dadurch können die Webserver vor direktem HTTP-Zugriff aus dem Internet geschützt werden.

---

## Application Security Group

APP01 befindet sich im privaten Subnetz und akzeptiert Anwendungsverkehr nur von den Webservern.

```hcl
ingress {
  description = "HTTP from Web Servers"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_groups = [aws_security_group.web.id]
}
```

## Code-Erklärung

```hcl
security_groups = [aws_security_group.web.id]
```

beschränkt den Zugriff auf Ressourcen, die zur Web Security Group gehören.

Direkter HTTP-Zugriff aus dem Internet auf APP01 wird dadurch nicht erlaubt.

Die Architektur folgt einem mehrschichtigen Modell:

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

---

# 8. EC2-Instanzen

Die EC2-Instanzen bilden die Compute-Schicht der Architektur.

```hcl
resource "aws_instance" "web01" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public1_subnet.id

  security_groups = [
    aws_security_group.web.id
  ]
}
```

## Code-Erklärung

* `aws_instance` erstellt eine EC2-Instanz.
* `ami` bestimmt das verwendete Betriebssystem-Image.
* `instance_type` bestimmt die Größe und Rechenkapazität der Instanz.
* `subnet_id` bestimmt, in welchem Subnetz die Instanz platziert wird.
* `security_groups` weist der Instanz die Web Security Group zu.

WEB01 befindet sich im ersten Public Subnet.

WEB02 wird nach demselben Prinzip erstellt, jedoch im zweiten Public Subnet und damit in einer anderen Availability Zone.

APP01 befindet sich im privaten Subnetz und benötigt keine öffentliche IP-Adresse.

---

# 9. Application Load Balancer

Der Application Load Balancer verteilt eingehenden HTTP-Traffic zwischen WEB01 und WEB02.

```hcl
resource "aws_lb" "main" {
  name = "aws-lab-alb"
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

## Code-Erklärung

* `aws_lb` erstellt einen Load Balancer.
* `load_balancer_type = "application"` definiert einen Application Load Balancer.
* Die beiden Subnetze ermöglichen den Betrieb des ALB über zwei Availability Zones.
* `security_groups` weist dem ALB die entsprechende Security Group zu.

Datenfluss:

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

Die Target Group definiert, an welche Backend-Instanzen der ALB den Traffic weiterleitet.

```hcl
resource "aws_lb_target_group" "web" {
  name = "aws-lab-web"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.benbenim.id
}
```

## Code-Erklärung

* `aws_lb_target_group` erstellt die Target Group.
* `port = 80` definiert den Port, auf dem die Backend-Webserver HTTP-Traffic empfangen.
* `protocol = "HTTP"` definiert das Kommunikationsprotokoll.
* `vpc_id` verbindet die Target Group mit der Lab-VPC.

WEB01 und WEB02 werden als Targets hinzugefügt, sodass der ALB Traffic an diese Server weiterleiten kann.

---

# 11. Kommunikation zwischen Web- und Application-Schicht

Die Webserver fungieren als Reverse Proxy und leiten Anfragen an das private APP01-Backend weiter.

Datenfluss:

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

## Code-Logik

Terraform stellt die notwendige Netzwerkstruktur und die Security-Group-Berechtigungen bereit.

Die eigentliche Reverse-Proxy-Konfiguration läuft auf den Webservern und leitet die Requests an die private IP-Adresse von APP01 weiter.

Dadurch kann APP01 ohne öffentliche IP-Adresse als Backend betrieben werden.

---

# 12. IAM

IAM-Ressourcen werden verwendet, um AWS-Identitäten über Terraform zu verwalten.

```hcl
resource "aws_iam_user" "lab_user" {
  name = "lab-user"
}
```

## Code-Erklärung

* `aws_iam_user` erstellt einen IAM-Benutzer.
* `name` definiert den Namen des Benutzers in AWS.

Die Berechtigungen des Benutzers können separat über Policies und Policy Attachments definiert werden.

Damit können sowohl Identitäten als auch deren Berechtigungen als Infrastructure as Code verwaltet werden.

---

# 13. CloudWatch Monitoring

CloudWatch Metric Alarms werden zur Überwachung der Infrastruktur verwendet.

```hcl
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  threshold = 80
}
```

## Code-Erklärung

* `aws_cloudwatch_metric_alarm` erstellt einen CloudWatch Alarm.
* `alarm_name` definiert den Namen des Alarms.
* `comparison_operator` definiert die Bedingung für die Bewertung der Metric.
* `threshold = 80` definiert den Schwellenwert.

Wenn die Metric die definierte Bedingung erfüllt, wechselt der Alarm seinen Status.

Damit wird eine grundlegende Monitoring- und Operational-Visibility-Schicht geschaffen.

---

# 14. Systems Manager Connectivity

AWS Systems Manager ermöglicht die Verwaltung von EC2-Instanzen, ohne dass eine direkte eingehende SSH-Verbindung erforderlich ist.

Für APP01 sieht der Datenfluss folgendermaßen aus:

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

## Code-Logik

Terraform erstellt die erforderlichen VPC Endpoints und Security-Group-Regeln.

Dadurch können Ressourcen im privaten Subnetz die benötigten AWS Systems Manager Services über das private Netzwerk erreichen.

APP01 kann dadurch:

* ohne öffentliche IP betrieben werden,
* ohne öffentlich geöffneten SSH-Port verwaltet werden,
* über AWS Systems Manager administriert werden.

---

# 15. S3 Lifecycle Management

Eine S3 Lifecycle Configuration automatisiert die Verwaltung der Lebensdauer von Objekten.

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

## Code-Erklärung

* `aws_s3_bucket_lifecycle_configuration` erstellt die Lifecycle-Konfiguration.
* `bucket` bestimmt den betroffenen S3-Bucket.
* `rule` definiert eine Lifecycle-Regel.
* `status = "Enabled"` aktiviert die Regel.
* `expiration` definiert den Ablaufzeitpunkt der Objekte.
* `days = 30` sorgt dafür, dass entsprechende Objekte nach 30 Tagen gelöscht werden.

Dadurch können alte Daten automatisch verwaltet werden, ohne dass eine manuelle Bereinigung erforderlich ist.

---

# 16. Terraform State

Terraform verwendet eine State-Datei, um den aktuellen Zustand der verwalteten Infrastruktur zu verfolgen.

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

## Code-Logik

Der Terraform State ermöglicht es Terraform:

* verwaltete Ressourcen zu identifizieren,
* den aktuellen Zustand der Infrastruktur zu verfolgen,
* Configuration und aktuellen State miteinander zu vergleichen,
* notwendige Änderungen während `terraform plan` zu erkennen.

Die State-Datei wird nicht in öffentlichen Dokumentationen veröffentlicht, da sie sensible Informationen über die Infrastruktur enthalten kann.

---

# 17. Terraform Workflow

Die Infrastruktur wird über den standardmäßigen Terraform-Workflow verwaltet.

```bash
terraform init
terraform plan
terraform apply
```

## `terraform init`

Initialisiert das Terraform-Arbeitsverzeichnis und lädt die benötigten Provider herunter.

## `terraform plan`

Vergleicht die Terraform-Konfiguration mit dem aktuellen State und zeigt an, welche Änderungen in AWS erforderlich wären.

In diesem Schritt werden noch keine Änderungen angewendet.

## `terraform apply`

Wendet die geplanten Änderungen tatsächlich auf die AWS-Infrastruktur an.

Nach der Übernahme der Lab-Infrastruktur in Terraform wurde die Konfiguration mit:

```bash
terraform plan
```

validiert.

Ein Ergebnis wie:

```text
No changes
```

bedeutet, dass zwischen der Terraform-Konfiguration und dem aktuellen Terraform State keine Änderungen erforderlich sind.

---

# 18. Infrastructure-as-Code-Modell

Terraform verwendet ein deklaratives Modell.

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

Terraform beschreibt dabei nicht primär, **welche einzelnen Befehle** ausgeführt werden sollen, sondern **wie der gewünschte Zustand der Infrastruktur aussehen soll**.

Terraform berechnet anschließend die Differenz zwischen dem aktuellen und dem gewünschten Zustand und führt die notwendigen Änderungen über die AWS API aus.

Dieser Ansatz ermöglicht:

* Wiederholbare Deployments
* Versionierung der Infrastruktur
* Konsistente Konfiguration
* Einfachere Änderungen
* Weniger manuelle Konfiguration
* Erkennung von Infrastructure Drift
* Reproduzierbare Umgebungen
* Infrastructure as Code
