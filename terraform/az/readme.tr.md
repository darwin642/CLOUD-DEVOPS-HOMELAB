# Azure Terraform Uygulaması

## Genel Bakış

Bu sayfa, lab ortamındaki Azure altyapısını oluşturmak ve yönetmek için kullanılan Terraform uygulamasını belgelemektedir.

Yapılandırma; altyapı, ağ, kimlik, depolama, yedekleme, izleme, erişim kontrolü ve VM yönetimini kapsamaktadır.

Terraform, bu kaynakları Azure Portal üzerinden manuel olarak yapılandırmak yerine kod olarak tanımlamak için kullanılmaktadır.

---

## Mimari

```text
                         Terraform
                             │
              ┌──────────────┴──────────────┐
              │                             │
         Microsoft Azure                Microsoft Entra ID
              │                             │
      ┌───────┼────────┐              ┌─────┴─────┐
      │       │        │              │           │
    Network   VM     Storage         Users      Group
      │       │        │
     NSG    Backup   Blob
     Route  Monitor  Container
     Table  Alerts
```

Azure Terraform uygulaması, uygun Terraform provider'ları aracılığıyla hem Azure altyapı kaynaklarını hem de Microsoft Entra ID kaynaklarını yönetmektedir.

---

## Proje Yapısı

```text
azure/
│
├── main.tf
├── provider.tf
├── terraform.tfvars
└── terraform.tfstate
```

### Dosya Özeti

| Dosya               | Amaç                                                                      |
| ------------------- | ------------------------------------------------------------------------- |
| `provider.tf`       | Terraform provider'ları, değişken tanımı ve Microsoft Entra ID kaynakları |
| `main.tf`           | Azure altyapı kaynakları                                                  |
| `terraform.tfvars`  | Terraform tarafından kullanılan değişken değerleri                        |
| `terraform.tfstate` | Deploy edilmiş altyapıyı temsil eden Terraform state dosyası              |

> **Not:** Terraform state dosyası, hassas altyapı bilgileri içerebileceği için bu dokümantasyona dahil edilmemiştir.

---

# 1. Provider Yapılandırması ve Kimlik

## `provider.tf`

`provider.tf` dosyası projede kullanılan Terraform provider'larını yapılandırır.

İki provider kullanılmaktadır:

* `azurerm` — Azure altyapısı için
* `azuread` — Microsoft Entra ID için

Dosya ayrıca lab kullanıcıları oluşturulurken kullanılacak hassas parola değişkenini tanımlar.

### Yapılandırma

```hcl
terraform { 
  required_providers { 
    azurerm = { 
      source  = "hashicorp/azurerm" 
      version = "~> 4.0" 
    } 
 
    azuread = { 
      source  = "hashicorp/azuread" 
      version = "~> 3.0" 
    } 
  } 
} 
 
provider "azurerm" { 
  features {} 
} 
 
provider "azuread" {} 
 
variable "lab_user_password" { 
  description = "Password for the lab Entra ID user" 
  type        = string 
  sensitive   = true 
}
```

` sensitive = true` ayarı, değişken değerinin Terraform komut çıktılarında normal şekilde gösterilmesini engeller.

---

## Microsoft Entra ID Kullanıcıları

Aynı dosya iki adet lab kullanıcısını da tanımlar.

```hcl
resource "azuread_user" "lab_user" { 
  user_principal_name   = "terraform-lab-user@kaanonyxhotmail.onmicrosoft.com" 
  display_name          = "Azure Terraform Lab User" 
  mail_nickname         = "terraform-lab-user" 
  password              = var.lab_user_password 
  force_password_change = false 
} 

resource "azuread_user" "lab_user2" { 
  user_principal_name   = "terraform-lab-user2@kaanonyxhotmail.onmicrosoft.com" 
  display_name          = "Azure Terraform Lab User 2" 
  mail_nickname         = "terraform-lab-user2" 
  password              = var.lab_user_password 
  force_password_change = false 
}
```

Kullanıcılar Microsoft Entra admin center üzerinden manuel olarak oluşturulmak yerine Terraform aracılığıyla oluşturulmaktadır.

---

## Microsoft Entra ID Grubu

İki kullanıcı bir security-enabled gruba eklenmektedir.

```hcl
resource "azuread_group" "lab_group" { 
  display_name     = "Azure Terraform Lab Group" 
  security_enabled = true 
 
  members = [ 
    azuread_user.lab_user.object_id, 
    azuread_user.lab_user2.object_id 
  ] 
}
```

Bu grup daha sonra Azure RBAC için kullanılmaktadır.

---

# 2. Resource Group ve Virtual Network

## Resource Group

Terraform, Terraform lab'ı için ana resource group'u oluşturur.

```hcl
resource "azurerm_resource_group" "az104_lab" {
  name     = "rg-az104-lab01"
  location = "westeurope"
}
```

Resource group, Azure kaynakları için mantıksal bir yönetim sınırı sağlar.

---

## Virtual Network

Lab VNet'i `10.10.0.0/16` adres alanını kullanmaktadır.

```hcl
resource "azurerm_virtual_network" "lab_vnet" {
  name                = "vnet-az104-tf01"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.az104_lab.name
  address_space       = ["10.10.0.0/16"]
}
```

Bu VNet, Terraform tarafından yönetilen Azure ortamı için ağ sınırını sağlar.

---

## Subnet

VNet içerisinde özel bir web subnet'i oluşturulmaktadır.

```hcl
resource "azurerm_subnet" "web_subnet" {
  name                 = "WebSubnet"
  resource_group_name  = azurerm_resource_group.az104_lab.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}
```

Subnet `10.10.1.0/24` adres alanını kullanır ve Terraform tarafından yönetilen web VM'ini barındırır.

---

# 3. Network Security

## Network Security Group

Web subnet'i bir NSG ile korunmaktadır.

```hcl
resource "azurerm_network_security_group" "web_nsg" {
  name                = "nsg-web-tf01"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.az104_lab.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```

NSG aşağıdaki inbound trafiğe izin vermektedir:

* TCP 3389 — RDP
* TCP 80 — HTTP

---

## NSG Association

NSG doğrudan web subnet'ine bağlanmaktadır.

```hcl
resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}
```

Böylece güvenlik kuralları subnet'e bağlı kaynaklara uygulanır.

---

# 4. Routing

Web subnet'i için bir route table oluşturulmaktadır.

```hcl
resource "azurerm_route_table" "web_rt" {
  name                = "rt-web-tf01"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.az104_lab.name

  route {
    name           = "DefaultRoute"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}
```

Varsayılan route, internet'e giden trafiği Azure Internet next hop üzerinden gönderir.

Route table daha sonra subnet'e bağlanır:

```hcl
resource "azurerm_subnet_route_table_association" "web_rt_assoc" {
  subnet_id      = azurerm_subnet.web_subnet.id
  route_table_id = azurerm_route_table.web_rt.id
}
```

---

# 5. Network Interface

Linux VM özel bir network interface kullanmaktadır.

```hcl
resource "azurerm_network_interface" "web_nic" {
  name                = "nic-web-tf01"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.az104_lab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
```

NIC, web subnet'inden dinamik bir private IP adresi alır.

---

# 6. Linux Virtual Machine

Ana compute kaynağı bir Ubuntu Linux VM'dir.

```hcl
resource "azurerm_linux_virtual_machine" "web_vm" {
  name                = "vm-web-tf01"
  resource_group_name = azurerm_resource_group.az104_lab.name
  location            = "swedencentral"
  size                = "Standard_B2ats_v2"

  admin_username = "azureuser"

  identity {
    type = "SystemAssigned"
  }

  network_interface_ids = [
    azurerm_network_interface.web_nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${pathexpand("~/.ssh/id_rsa.pub")}")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
```

VM şu özellikleri kullanmaktadır:

* Ubuntu 24.04 LTS
* `Standard_B2ats_v2`
* System-assigned managed identity
* SSH key authentication
* Standard LRS OS disk
* Dynamic private IP addressing

VM üzerinde hardcoded SSH public key kullanılmasına gerek yoktur; Terraform public key'i kullanıcının SSH dizininden okumaktadır.

---

# 7. Storage

## Storage Account

Terraform, blob versioning ve retention ayarlarına sahip bir Azure Storage Account oluşturur.

```hcl
resource "azurerm_storage_account" "lab_storage" {
  name                     = "az104tflab3531"
  resource_group_name      = azurerm_resource_group.az104_lab.name
  location                 = "swedencentral"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }
}
```

Yapılandırma şunları etkinleştirir:

* Standard storage
* Locally Redundant Storage
* Blob versioning
* 7 günlük blob delete retention
* 7 günlük container delete retention

---

## Blob Container

Storage Account içerisinde private bir blob container oluşturulur.

```hcl
resource "azurerm_storage_container" "lab_container" {
  name                  = "lab-data"
  storage_account_id    = azurerm_storage_account.lab_storage.id
  container_access_type = "private"
}
```

Container public erişim yerine private olarak yapılandırılmıştır.

---

## Storage Immutability

Container için yedi günlük bir immutability policy yapılandırılmıştır.

```hcl
resource "azurerm_storage_container_immutability_policy" "lab_policy" {
  storage_container_resource_manager_id = azurerm_storage_container.lab_container.id
  immutability_period_in_days           = 7
  protected_append_writes_all_enabled   = false
  locked                                = false
}
```

Bu policy, depolanan veriler için retention ve immutability kontrollerinin kullanımını göstermektedir.

---

# 8. Managed Identity ve RBAC

VM system-assigned managed identity kullanmaktadır.

Terraform bu identity'ye storage account üzerinde `Storage Blob Data Reader` rolünü verir.

```hcl
resource "azurerm_role_assignment" "vm_storage_reader" {
  scope                = azurerm_storage_account.lab_storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_virtual_machine.web_vm.identity[0].principal_id
}
```

Bu sayede VM identity'si, storage credential'larını doğrudan VM üzerinde saklamadan blob verilerine erişebilir.

---

## Group RBAC

Daha önce oluşturulan Microsoft Entra ID grubuna resource group üzerinde Reader rolü verilir.

```hcl
resource "azurerm_role_assignment" "lab_group_reader" {
  scope                = azurerm_resource_group.az104_lab.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.lab_group.object_id
}
```

Bu, grup tabanlı yetkilendirme ile role-based access control kullanımını göstermektedir.

---

# 9. Backup

## Recovery Services Vault

Terraform, VM backup işlemleri için bir Recovery Services Vault oluşturur.

```hcl
resource "azurerm_recovery_services_vault" "lab_vault" {
  name                = "vault-az104-lab01"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.az104_lab.name
  sku                 = "RS0"
}
```

---

## Backup Policy

Günlük bir backup policy yapılandırılmıştır.

```hcl
resource "azurerm_backup_policy_vm" "lab_backup_policy" {
  name                = "vm-backup-policy-tf01"
  resource_group_name = azurerm_resource_group.az104_lab.name
  recovery_vault_name = azurerm_recovery_services_vault.lab_vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}
```

Policy:

* Günlük backup
* 23:00 UTC zamanlaması
* 7 günlük günlük retention

uygulamaktadır.

---

## Protected VM

Linux VM backup policy'ye bağlanır.

```hcl
resource "azurerm_backup_protected_vm" "web_vm_backup" {
  resource_group_name = azurerm_resource_group.az104_lab.name
  recovery_vault_name = azurerm_recovery_services_vault.lab_vault.name
  source_vm_id        = azurerm_linux_virtual_machine.web_vm.id
  backup_policy_id    = azurerm_backup_policy_vm.lab_backup_policy.id
}
```

---

# 10. Monitoring

## Action Group

Alert bildirimleri için bir Azure Monitor Action Group yapılandırılmıştır.

```hcl
resource "azurerm_monitor_action_group" "lab_alerts" {
  name                = "ag-az104-tf01"
  resource_group_name = azurerm_resource_group.az104_lab.name
  short_name          = "az104alert"

  email_receiver {
    name                    = "my-email"
    email_address           = "kaan2002tf2@gmail.com"
    use_common_alert_schema = true
  }
}
```

Action Group, monitoring alert'leri için bildirim hedefini sağlar.

---

## CPU Alert

VM CPU kullanımını izlemek için metric alert kullanılmaktadır.

```hcl
resource "azurerm_monitor_metric_alert" "web_vm_cpu" {
  name                = "alert-vm-web-tf01-cpu"
  resource_group_name = azurerm_resource_group.az104_lab.name
  scopes              = [azurerm_linux_virtual_machine.web_vm.id]

  description = "Alert when VM CPU usage exceeds 80%"
  severity    = 2
  frequency   = "PT5M"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.lab_alerts.id
  }
}
```

Alert, yapılandırılmış monitoring window içerisinde ortalama VM CPU kullanımı **%80'i aştığında** tetiklenir.

---

# 11. Resource Lock

Bir management lock, resource group'u yanlışlıkla silinmeye karşı korur.

```hcl
resource "azurerm_management_lock" "lab_rg_lock" {
  name       = "lock-az104-tf01"
  scope      = azurerm_resource_group.az104_lab.id
  lock_level = "CanNotDelete"
  notes      = "Protect Azure Terraform lab resources from accidental deletion"
}
```

`CanNotDelete` lock'ı kaynakların değiştirilmesine izin verirken yanlışlıkla silinmesini engeller.

---

# 12. Tailscale VM Extension

Linux VM üzerine Tailscale kurmak için bir Custom Script VM extension kullanılmaktadır.

```hcl
resource "azurerm_virtual_machine_extension" "tailscale" {
  name                 = "tailscale"
  virtual_machine_id   = azurerm_linux_virtual_machine.web_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = "curl -fsSL https://pkgs.tailscale.com/stable/tailscale_1.88.3_amd64.tgz -o /tmp/tailscale.tgz && tar -xzf /tmp/tailscale.tgz -C /tmp && cp /tmp/tailscale_1.88.3_amd64/tailscale /usr/local/bin/tailscale && cp /tmp/tailscale_1.88.3_amd64/tailscaled /usr/local/bin/tailscaled"
  })
}
```

Bu, Terraform'un VM extension'ları aracılığıyla deployment sonrasındaki VM yapılandırmasını da yönetebildiğini göstermektedir.

---

# 13. Outputs

Terraform, VM'in private IP adresini output olarak sunar.

```hcl
output "web_vm_private_ip" {
  description = "Private IP address of the web VM"
  value       = azurerm_network_interface.web_nic.private_ip_address
}
```

Bu sayede deployment sonrasında Azure Portal'ı manuel olarak kontrol etmeye gerek kalmadan private IP görüntülenebilir.

---

# 14. Variables

## `terraform.tfvars`

Hassas lab kullanıcı parolası bir Terraform variable aracılığıyla sağlanır.

```hcl
lab_user_password = ""
```

Gerçek secret source control sistemine commit edilmemelidir.

Gerçek bir deployment ortamında hassas değişkenler environment variable, secret manager veya korumalı CI/CD pipeline gibi güvenli yöntemlerle sağlanmalıdır.

---

# 15. Terraform Workflow

Azure ortamı standart Terraform workflow'unu takip etmektedir:

```text
Terraform Configuration
        │
        ▼
terraform init
        │
        ▼
terraform validate
        │
        ▼
terraform plan
        │
        ▼
terraform apply
        │
        ▼
Azure Infrastructure
        │
        ▼
terraform.tfstate
```

### Initialize

```bash
terraform init
```

Gerekli Terraform provider'larını indirir ve çalışma dizinini başlatır.

### Validate

```bash
terraform validate
```

Terraform configuration'ın syntax açısından geçerli olup olmadığını kontrol eder.

### Plan

```bash
terraform plan
```

Terraform'un uygulamayı planladığı altyapı değişikliklerini gösterir.

### Apply

```bash
terraform apply
```

Planlanan configuration'ı Azure'a uygular.

---

# 16. Terraform State

Terraform, configuration tarafından yönetilen kaynakları takip etmek için bir state dosyası tutar.

```text
terraform.tfstate
```

Azure state'i aşağıdaki kaynaklar hakkında bilgiler içerir:

* Resource Group
* Virtual Network
* Subnet
* NSG
* Route Table
* Network Interface
* Linux VM
* Storage Account
* RBAC assignments
* Backup resources
* Monitoring resources
* Resource Lock
* VM Extension
* Microsoft Entra ID resources

State dosyasının kendisi, resource identifier'ları, credential'lar ve diğer altyapı bilgileri gibi hassas veriler içerebileceği için dokümantasyonda okunabilir içerik olarak paylaşılmamıştır.

---

# 17. Security Considerations

Terraform uygulaması çeşitli güvenlik kontrolleri içermektedir:

* Hassas değişkenler `sensitive = true` olarak işaretlenmiştir.
* Storage container'lar private olarak yapılandırılmıştır.
* Gereksiz şekilde geniş izinler yerine Azure RBAC kullanılmaktadır.
* VM storage erişimi için managed identity kullanmaktadır.
* Resource group üzerinde `CanNotDelete` management lock bulunmaktadır.
* Terraform state public erişime karşı korunmalıdır.
* Secret'lar Git'e commit edilmemelidir.
* Secret içeren `.tfvars` dosyaları version control dışında tutulmalıdır.

Önerilen `.gitignore` girdileri:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.tfvars.json
```

---

# 18. Yönetilen Kaynaklar

Azure Terraform uygulaması aşağıdaki temel bileşenleri yönetmektedir:

| Kategori         | Kaynaklar                                            |
| ---------------- | ---------------------------------------------------- |
| Identity         | Entra ID Users, Entra ID Group                       |
| Compute          | Linux Virtual Machine                                |
| Networking       | VNet, Subnet, NIC, NSG, Route Table                  |
| Storage          | Storage Account, Blob Container, Immutability Policy |
| Access Control   | Azure RBAC                                           |
| Backup           | Recovery Services Vault, Backup Policy, Protected VM |
| Monitoring       | Action Group, CPU Metric Alert                       |
| Protection       | Resource Lock                                        |
| VM Configuration | Tailscale VM Extension                               |
| Outputs          | VM Private IP                                        |

---

# 19. Önemli Kazanımlar

Bu Azure Terraform uygulaması aşağıdaki pratik becerileri göstermektedir:

* Infrastructure as Code
* Terraform providers
* Azure resource provisioning
* Virtual networking
* Network security
* Routing
* Linux VM deployment
* Managed identities
* Azure RBAC
* Microsoft Entra ID automation
* Azure Storage
* Backup configuration
* Azure Monitor
* Resource protection
* VM extensions
* Terraform state management

Bu yapılandırma, Azure lab ortamını tekrarlanabilir şekilde deploy etmeyi ve yönetmeyi sağlarken altyapı tanımlarını version-controlled kod içerisinde tutmaktadır.
