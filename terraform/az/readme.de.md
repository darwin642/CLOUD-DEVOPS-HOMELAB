# Azure Terraform Implementierung

## Überblick

Diese Seite dokumentiert die Terraform-Implementierung zur Bereitstellung und Verwaltung der Azure-Infrastruktur in der Lab-Umgebung.

Die Konfiguration umfasst Infrastruktur, Netzwerk, Identität, Storage, Backup, Monitoring, Zugriffskontrolle und VM-Verwaltung.

Terraform wird verwendet, um diese Ressourcen als Code zu definieren, anstatt sie manuell über das Azure Portal zu konfigurieren.

---

## Architektur

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

Die Azure-Terraform-Implementierung verwaltet sowohl Azure-Infrastrukturressourcen als auch Microsoft-Entra-ID-Ressourcen über die entsprechenden Terraform Provider.

---

## Projektstruktur

```text
azure/
│
├── main.tf
├── provider.tf
├── terraform.tfvars
└── terraform.tfstate
```

### Dateiübersicht

| Datei               | Zweck                                                                     |
| ------------------- | ------------------------------------------------------------------------- |
| `provider.tf`       | Terraform Provider, Variablendefinition und Microsoft-Entra-ID-Ressourcen |
| `main.tf`           | Azure-Infrastrukturressourcen                                             |
| `terraform.tfvars`  | Von Terraform verwendete Variablenwerte                                   |
| `terraform.tfstate` | Terraform State der bereitgestellten Infrastruktur                        |

> **Hinweis:** Die Terraform-State-Datei ist nicht Bestandteil dieser Dokumentation, da State-Dateien sensible Infrastrukturinformationen enthalten können.

---

# 1. Provider-Konfiguration und Identität

## `provider.tf`

Die Datei `provider.tf` konfiguriert die in diesem Projekt verwendeten Terraform Provider.

Es werden zwei Provider verwendet:

* `azurerm` für Azure-Infrastruktur
* `azuread` für Microsoft Entra ID

Die Datei definiert außerdem die sensible Passwortvariable, die beim Erstellen der Lab-Benutzer verwendet wird.

### Konfiguration

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

Die Einstellung `sensitive = true` verhindert, dass der Wert der Variable normalerweise in der Terraform-Konsolenausgabe angezeigt wird.

---

## Microsoft-Entra-ID-Benutzer

In derselben Datei werden außerdem zwei Lab-Benutzer definiert.

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

Die Benutzer werden über Terraform erstellt, anstatt sie manuell im Microsoft Entra Admin Center anzulegen.

---

## Microsoft-Entra-ID-Gruppe

Die beiden Benutzer werden einer security-enabled Gruppe hinzugefügt.

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

Diese Gruppe wird später für Azure RBAC verwendet.

---

# 2. Resource Group und Virtual Network

## Resource Group

Die Terraform-Konfiguration erstellt die zentrale Resource Group für das Terraform-Lab.

```hcl
resource "azurerm_resource_group" "az104_lab" {
  name     = "rg-az104-lab01"
  location = "westeurope"
}
```

Die Resource Group dient als logische Verwaltungseinheit für die Azure-Ressourcen.

---

## Virtual Network

Das Lab-VNet verwendet den Adressbereich `10.10.0.0/16`.

```hcl
resource "azurerm_virtual_network" "lab_vnet" {
  name                = "vnet-az104-tf01"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.az104_lab.name
  address_space       = ["10.10.0.0/16"]
}
```

Dieses VNet stellt die Netzwerkgrenze für die von Terraform verwaltete Azure-Umgebung bereit.

---

## Subnet

Innerhalb des VNets wird ein dediziertes Web-Subnet erstellt.

```hcl
resource "azurerm_subnet" "web_subnet" {
  name                 = "WebSubnet"
  resource_group_name  = azurerm_resource_group.az104_lab.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}
```

Das Subnet verwendet `10.10.1.0/24` und hostet die von Terraform verwaltete Web-VM.

---

# 3. Network Security

## Network Security Group

Das Web-Subnet wird durch eine NSG geschützt.

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

Die NSG erlaubt eingehenden:

* TCP 3389 für RDP
* TCP 80 für HTTP

---

## NSG Association

Die NSG wird direkt mit dem Web-Subnet verbunden.

```hcl
resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}
```

Dadurch werden die Sicherheitsregeln auf die mit dem Subnet verbundenen Ressourcen angewendet.

---

# 4. Routing

Für das Web-Subnet wird eine Route Table erstellt.

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

Die Standardroute leitet internetgebundenen Traffic über den Azure-Internet-Next-Hop weiter.

Die Route Table wird anschließend mit dem Subnet verbunden:

```hcl
resource "azurerm_subnet_route_table_association" "web_rt_assoc" {
  subnet_id      = azurerm_subnet.web_subnet.id
  route_table_id = azurerm_route_table.web_rt.id
}
```

---

# 5. Network Interface

Die Linux-VM verwendet eine eigene Network Interface.

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

Die NIC erhält eine dynamische private IP-Adresse aus dem Web-Subnet.

---

# 6. Linux Virtual Machine

Die zentrale Compute-Ressource ist eine Ubuntu-Linux-VM.

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

Die VM verwendet:

* Ubuntu 24.04 LTS
* `Standard_B2ats_v2`
* System-assigned Managed Identity
* SSH-Key-Authentifizierung
* Standard-LRS-OS-Disk
* Dynamische private IP-Adresse

Ein fest codierter SSH Public Key ist nicht erforderlich, da Terraform den Public Key aus dem lokalen SSH-Verzeichnis des Benutzers liest.

---

# 7. Storage

## Storage Account

Terraform erstellt einen Azure Storage Account mit Blob-Versionierung und Retention-Einstellungen.

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

Die Konfiguration aktiviert:

* Standard Storage
* Locally Redundant Storage
* Blob-Versionierung
* 7 Tage Blob Delete Retention
* 7 Tage Container Delete Retention

---

## Blob Container

Innerhalb des Storage Accounts wird ein privater Blob Container erstellt.

```hcl
resource "azurerm_storage_container" "lab_container" {
  name                  = "lab-data"
  storage_account_id    = azurerm_storage_account.lab_storage.id
  container_access_type = "private"
}
```

Der Container ist nicht öffentlich, sondern als privat konfiguriert.

---

## Storage Immutability

Für den Container wird eine sieben Tage lange Immutability Policy konfiguriert.

```hcl
resource "azurerm_storage_container_immutability_policy" "lab_policy" {
  storage_container_resource_manager_id = azurerm_storage_container.lab_container.id
  immutability_period_in_days           = 7
  protected_append_writes_all_enabled   = false
  locked                                = false
}
```

Die Policy demonstriert die Verwendung von Retention- und Immutability-Kontrollen für gespeicherte Daten.

---

# 8. Managed Identity und RBAC

Die VM verwendet eine system-assigned Managed Identity.

Terraform weist dieser Identity die Rolle `Storage Blob Data Reader` auf dem Storage Account zu.

```hcl
resource "azurerm_role_assignment" "vm_storage_reader" {
  scope                = azurerm_storage_account.lab_storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_virtual_machine.web_vm.identity[0].principal_id
}
```

Dadurch kann die VM-Identity auf Blob-Daten zugreifen, ohne Storage Credentials direkt auf der VM speichern zu müssen.

---

## Group RBAC

Die zuvor erstellte Microsoft-Entra-ID-Gruppe erhält die Rolle Reader auf der Resource Group.

```hcl
resource "azurerm_role_assignment" "lab_group_reader" {
  scope                = azurerm_resource_group.az104_lab.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.lab_group.object_id
}
```

Dies demonstriert Role-Based Access Control über gruppenbasierte Berechtigungen.

---

# 9. Backup

## Recovery Services Vault

Terraform erstellt einen Recovery Services Vault für VM-Backups.

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

Eine tägliche Backup Policy wird konfiguriert.

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

Die Policy führt Folgendes durch:

* Tägliche Backups
* Zeitplan um 23:00 UTC
* 7 Tage tägliche Retention

---

## Protected VM

Die Linux-VM wird mit der Backup Policy verbunden.

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

Für Alert-Benachrichtigungen wird eine Azure Monitor Action Group konfiguriert.

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

Die Action Group stellt das Benachrichtigungsziel für Monitoring Alerts bereit.

---

## CPU Alert

Zur Überwachung der VM-CPU-Auslastung wird ein Metric Alert verwendet.

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

Der Alert wird ausgelöst, wenn die durchschnittliche CPU-Auslastung der VM innerhalb des konfigurierten Monitoring-Fensters **80 % überschreitet**.

---

# 11. Resource Lock

Ein Management Lock schützt die Resource Group vor versehentlichem Löschen.

```hcl
resource "azurerm_management_lock" "lab_rg_lock" {
  name       = "lock-az104-tf01"
  scope      = azurerm_resource_group.az104_lab.id
  lock_level = "CanNotDelete"
  notes      = "Protect Azure Terraform lab resources from accidental deletion"
}
```

Der `CanNotDelete` Lock verhindert versehentliches Löschen, während Änderungen an den Ressourcen weiterhin möglich sind.

---

# 12. Tailscale VM Extension

Eine Custom-Script-VM-Extension wird verwendet, um Tailscale auf der Linux-VM zu installieren.

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

Dies zeigt, dass Terraform über VM Extensions auch die Konfiguration einer VM nach dem Deployment verwalten kann.

---

# 13. Outputs

Terraform stellt die private IP-Adresse der VM als Output bereit.

```hcl
output "web_vm_private_ip" {
  description = "Private IP address of the web VM"
  value       = azurerm_network_interface.web_nic.private_ip_address
}
```

Dadurch kann die private IP nach dem Deployment angezeigt werden, ohne sie manuell im Azure Portal suchen zu müssen.

---

# 14. Variables

## `terraform.tfvars`

Das sensible Passwort des Lab-Benutzers wird über eine Terraform-Variable bereitgestellt.

```hcl
lab_user_password = ""
```

Das tatsächliche Secret sollte nicht in das Source-Control-System übernommen werden.

In einer realen Deployment-Umgebung sollten sensible Variablen über sichere Mechanismen wie Environment Variables, einen Secret Manager oder eine geschützte CI/CD-Pipeline bereitgestellt werden.

---

# 15. Terraform Workflow

Die Azure-Umgebung folgt dem standardmäßigen Terraform-Workflow:

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

Lädt die erforderlichen Terraform Provider herunter und initialisiert das Arbeitsverzeichnis.

### Validate

```bash
terraform validate
```

Überprüft, ob die Terraform-Konfiguration syntaktisch gültig ist.

### Plan

```bash
terraform plan
```

Zeigt die Infrastrukturänderungen an, die Terraform durchführen möchte.

### Apply

```bash
terraform apply
```

Wendet die geplante Konfiguration auf Azure an.

---

# 16. Terraform State

Terraform verwendet eine State-Datei, um die von der Konfiguration verwalteten Ressourcen nachzuverfolgen.

```text
terraform.tfstate
```

Der Azure State enthält Informationen über Ressourcen wie:

* Resource Group
* Virtual Network
* Subnet
* NSG
* Route Table
* Network Interface
* Linux VM
* Storage Account
* RBAC Assignments
* Backup Resources
* Monitoring Resources
* Resource Lock
* VM Extension
* Microsoft-Entra-ID-Ressourcen

Die State-Datei selbst wird nicht als lesbarer Inhalt dokumentiert oder veröffentlicht, da sie sensible Informationen wie Resource IDs, Credentials und andere Infrastrukturinformationen enthalten kann.

---

# 17. Sicherheitsaspekte

Die Terraform-Implementierung enthält verschiedene Sicherheitskontrollen:

* Sensible Variablen sind mit `sensitive = true` gekennzeichnet.
* Storage Container sind als privat konfiguriert.
* Azure RBAC wird anstelle unnötig weitreichender Berechtigungen verwendet.
* Die VM verwendet eine Managed Identity für den Storage-Zugriff.
* Die Resource Group verfügt über einen `CanNotDelete` Management Lock.
* Der Terraform State sollte vor öffentlichem Zugriff geschützt werden.
* Secrets sollten nicht in Git committed werden.
* `.tfvars`-Dateien mit Secrets sollten vom Version Control ausgeschlossen werden.

Empfohlene `.gitignore`-Einträge:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.tfvars.json
```

---

# 18. Verwaltete Ressourcen

Die Azure-Terraform-Implementierung verwaltet folgende Hauptkomponenten:

| Kategorie        | Ressourcen                                           |
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

# 19. Zentrale Erkenntnisse

Diese Azure-Terraform-Implementierung demonstriert praktische Kenntnisse in:

* Infrastructure as Code
* Terraform Providern
* Azure Resource Provisioning
* Virtual Networking
* Network Security
* Routing
* Linux VM Deployment
* Managed Identities
* Azure RBAC
* Microsoft-Entra-ID-Automatisierung
* Azure Storage
* Backup-Konfiguration
* Azure Monitor
* Ressourcenschutz
* VM Extensions
* Terraform State Management

Die Konfiguration ermöglicht eine wiederholbare Bereitstellung und Verwaltung der Azure-Lab-Umgebung, während die Infrastrukturdefinition in versioniertem Code gehalten wird.
