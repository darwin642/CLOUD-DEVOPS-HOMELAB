# Azure Terraform Implementation

## Overview

This page documents the Terraform implementation used to provision and manage the Azure infrastructure in the lab environment.

The configuration covers infrastructure, networking, identity, storage, backup, monitoring, access control, and VM management.

Terraform is used to define these resources as code instead of configuring them manually through the Azure Portal.

---

## Architecture

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

The Azure Terraform implementation manages both Azure infrastructure resources and Microsoft Entra ID resources through the appropriate Terraform providers.

---

## Project Structure

```text
azure/
│
├── main.tf
├── provider.tf
├── terraform.tfvars
└── terraform.tfstate
```

### File Overview

| File                | Purpose                                                                    |
| ------------------- | -------------------------------------------------------------------------- |
| `provider.tf`       | Terraform providers, variable definition, and Microsoft Entra ID resources |
| `main.tf`           | Azure infrastructure resources                                             |
| `terraform.tfvars`  | Variable values used by Terraform                                          |
| `terraform.tfstate` | Terraform state representing the deployed infrastructure                   |

> **Note:** The Terraform state file is not included in this documentation because state files can contain sensitive infrastructure information.

---

# 1. Provider Configuration and Identity

## `provider.tf`

The `provider.tf` file configures the Terraform providers used by the project.

Two providers are used:

* `azurerm` for Azure infrastructure
* `azuread` for Microsoft Entra ID

The file also defines the sensitive password variable used when creating the lab users.

### Configuration

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

The `sensitive = true` setting prevents Terraform from displaying the variable value normally in command output.

---

## Microsoft Entra ID Users

The same file also defines two lab users.

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

The users are created through Terraform instead of being manually created in the Microsoft Entra admin center.

---

## Microsoft Entra ID Group

The two users are placed into a security-enabled group.

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

This group is later used for Azure RBAC.

---

# 2. Resource Group and Virtual Network

## Resource Group

The Terraform configuration creates the main resource group for the Terraform lab.

```hcl
resource "azurerm_resource_group" "az104_lab" {
  name     = "rg-az104-lab01"
  location = "westeurope"
}
```

The resource group provides the logical management boundary for the Azure resources.

---

## Virtual Network

The lab VNet uses the `10.10.0.0/16` address space.

```hcl
resource "azurerm_virtual_network" "lab_vnet" {
  name                = "vnet-az104-tf01"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.az104_lab.name
  address_space       = ["10.10.0.0/16"]
}
```

This VNet provides the network boundary for the Terraform-managed Azure environment.

---

## Subnet

A dedicated web subnet is created inside the VNet.

```hcl
resource "azurerm_subnet" "web_subnet" {
  name                 = "WebSubnet"
  resource_group_name  = azurerm_resource_group.az104_lab.name
  virtual_network_name = azurerm_virtual_network.lab_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}
```

The subnet uses `10.10.1.0/24` and hosts the Terraform-managed web VM.

---

# 3. Network Security

## Network Security Group

The web subnet is protected by an NSG.

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

The NSG allows inbound:

* TCP 3389 for RDP
* TCP 80 for HTTP

---

## NSG Association

The NSG is associated directly with the web subnet.

```hcl
resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}
```

This means the security rules apply to resources connected to the subnet.

---

# 4. Routing

A route table is created for the web subnet.

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

The default route sends internet-bound traffic through the Azure Internet next hop.

The route table is then associated with the subnet:

```hcl
resource "azurerm_subnet_route_table_association" "web_rt_assoc" {
  subnet_id      = azurerm_subnet.web_subnet.id
  route_table_id = azurerm_route_table.web_rt.id
}
```

---

# 5. Network Interface

The Linux VM uses a dedicated network interface.

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

The NIC receives a dynamic private IP address from the web subnet.

---

# 6. Linux Virtual Machine

The main compute resource is an Ubuntu Linux VM.

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

The VM uses:

* Ubuntu 24.04 LTS
* `Standard_B2ats_v2`
* System-assigned managed identity
* SSH key authentication
* Standard LRS OS disk
* Dynamic private IP addressing

The VM does not require a hardcoded SSH public key because Terraform reads the local public key from the user's SSH directory.

---

# 7. Storage

## Storage Account

Terraform creates an Azure Storage Account with blob versioning and retention settings.

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

The configuration enables:

* Standard storage
* Locally Redundant Storage
* Blob versioning
* 7-day blob delete retention
* 7-day container delete retention

---

## Blob Container

A private blob container is created inside the storage account.

```hcl
resource "azurerm_storage_container" "lab_container" {
  name                  = "lab-data"
  storage_account_id    = azurerm_storage_account.lab_storage.id
  container_access_type = "private"
}
```

The container is configured as private rather than publicly accessible.

---

## Storage Immutability

A seven-day immutability policy is configured for the container.

```hcl
resource "azurerm_storage_container_immutability_policy" "lab_policy" {
  storage_container_resource_manager_id = azurerm_storage_container.lab_container.id
  immutability_period_in_days           = 7
  protected_append_writes_all_enabled   = false
  locked                                = false
}
```

The policy demonstrates the use of retention and immutability controls for stored data.

---

# 8. Managed Identity and RBAC

The VM uses a system-assigned managed identity.

Terraform grants that identity the `Storage Blob Data Reader` role on the storage account.

```hcl
resource "azurerm_role_assignment" "vm_storage_reader" {
  scope                = azurerm_storage_account.lab_storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_virtual_machine.web_vm.identity[0].principal_id
}
```

This allows the VM identity to access blob data without storing storage credentials directly on the VM.

---

## Group RBAC

The Microsoft Entra ID group created earlier receives the Reader role on the resource group.

```hcl
resource "azurerm_role_assignment" "lab_group_reader" {
  scope                = azurerm_resource_group.az104_lab.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.lab_group.object_id
}
```

This demonstrates role-based access control using group-based permissions.

---

# 9. Backup

## Recovery Services Vault

Terraform creates a Recovery Services Vault for VM backup.

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

A daily backup policy is configured.

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

The policy performs:

* Daily backups
* 23:00 UTC schedule
* 7-day daily retention

---

## Protected VM

The Linux VM is registered with the backup policy.

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

An Azure Monitor Action Group is configured for alert notifications.

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

The Action Group provides the notification destination for monitoring alerts.

---

## CPU Alert

A metric alert monitors VM CPU usage.

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

The alert triggers when average VM CPU usage exceeds **80%** during the configured monitoring window.

---

# 11. Resource Lock

A management lock protects the resource group from accidental deletion.

```hcl
resource "azurerm_management_lock" "lab_rg_lock" {
  name       = "lock-az104-tf01"
  scope      = azurerm_resource_group.az104_lab.id
  lock_level = "CanNotDelete"
  notes      = "Protect Azure Terraform lab resources from accidental deletion"
}
```

The `CanNotDelete` lock prevents accidental deletion while still allowing resources to be modified.

---

# 12. Tailscale VM Extension

A Custom Script VM extension is used to install Tailscale on the Linux VM.

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

This demonstrates how Terraform can also manage post-deployment VM configuration through extensions.

---

# 13. Outputs

Terraform exposes the VM's private IP address as an output.

```hcl
output "web_vm_private_ip" {
  description = "Private IP address of the web VM"
  value       = azurerm_network_interface.web_nic.private_ip_address
}
```

This allows the private IP to be displayed after deployment without manually checking the Azure Portal.

---

# 14. Variables

## `terraform.tfvars`

The sensitive lab user password is supplied through a Terraform variable.

```hcl
lab_user_password = ""
```

The actual secret should not be committed to source control.

For a real deployment, sensitive variables should be supplied through a secure mechanism such as environment variables, a secret manager, or a protected CI/CD pipeline.

---

# 15. Terraform Workflow

The Azure environment follows the standard Terraform workflow:

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

Downloads the required Terraform providers and initializes the working directory.

### Validate

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid.

### Plan

```bash
terraform plan
```

Shows the infrastructure changes Terraform intends to make.

### Apply

```bash
terraform apply
```

Applies the planned configuration to Azure.

---

# 16. Terraform State

Terraform maintains a state file to track the resources managed by the configuration.

```text
terraform.tfstate
```

The Azure state contains information about resources such as:

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

The state file itself is **not documented or committed as readable content** because Terraform state can contain sensitive information such as resource identifiers, credentials, and other infrastructure data.

---

# 17. Security Considerations

The Terraform implementation contains several security-related controls:

* Sensitive variables are marked with `sensitive = true`.
* Storage containers are configured as private.
* Azure RBAC is used instead of unnecessarily broad permissions.
* The VM uses a managed identity for storage access.
* The resource group has a `CanNotDelete` management lock.
* Terraform state should be protected from public access.
* Secrets should not be committed to Git.
* `.tfvars` files containing secrets should be excluded from version control.

Recommended `.gitignore` entries:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.tfvars.json
```

---

# 18. Resources Managed

The Azure Terraform implementation manages the following major components:

| Category         | Resources                                            |
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

# 19. Key Takeaways

This Azure Terraform implementation demonstrates practical experience with:

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

The configuration provides a repeatable way to deploy and manage the Azure lab while keeping the infrastructure definition in version-controlled code.
