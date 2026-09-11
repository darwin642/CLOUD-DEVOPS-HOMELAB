# ☁️ Microsoft Azure Infrastructure Lab

Praktisches Azure-Infrastrukturlabor zur Entwicklung von praxisnahen Kenntnissen in Cloud-Infrastruktur, Networking, Security, Identity, Storage und Systemadministration.

Der Schwerpunkt des Labors liegt auf dem Aufbau, der Konfiguration, dem Testen und der Fehlerbehebung einer realistischen Azure-Infrastruktur.

---

## 📌 Projektübersicht

Dieses Labor umfasst die Bereitstellung und Konfiguration einer kleinen Azure-Infrastruktur.

Das Projekt umfasst:

* Azure Virtual Network
* Subnetze
* Network Security Groups
* Netzwerk-Routing
* Windows Server Virtual Machine
* Azure Storage
* Private Endpoint
* Private DNS
* Managed Identity
* Azure CLI
* Role-Based Access Control
* Netzwerk-Fehlerbehebung

---

## 🏗️ Architektur

### Architekturdiagramm

> **[IHR AZURE-ARCHITEKTURDIAGRAMM HIER EINFÜGEN]**

<!-- Fügen Sie hier Ihr Azure-Architekturdiagramm ein -->

Die Umgebung enthält ein Azure Virtual Network mit einer definierten Subnetzstruktur, einer Windows Server Virtual Machine, Netzwerk-Sicherheitskontrollen und privater Konnektivität zu Azure Storage.

---

## 1. 🌐 Virtual Network & Subnetze

Die Azure-Netzwerkinfrastruktur wurde mit einem dedizierten Virtual Network und einer strukturierten Subnetzarchitektur erstellt.

### Konfiguration

| Ressource       | Konfiguration      |
| --------------- | ------------------ |
| Resource Group  | `rg-az104-lab01`   |
| Virtual Network | `vnet-az104-lab01` |
| Address Space   | `10.0.0.0/16`      |
| Subnetz         | `WebSubnet`        |
| Subnetzbereich  | `10.0.1.0/24`      |
| Region          | Sweden Central     |

### 📸 Screenshot 01 — Resource Group

![Resource Group](./images/01-resource-group.png)

### 📸 Screenshot 02 — Virtual Network

![Virtual Network](./images/02-virtual-network.png)

### 📸 Screenshot 03 — Subnetzkonfiguration

![Subnet Configuration](./images/03-subnet.png)

---

## 2. 🔐 Netzwerksicherheit

Der Netzwerkverkehr wurde mithilfe von Network Security Groups kontrolliert.

Eine NSG wurde dem WebSubnet zugewiesen, um eingehenden und ausgehenden Datenverkehr zu kontrollieren.

### Konfiguration

* Network Security Group: `nsg-web`
* Subnetz-Zuordnung: `WebSubnet`
* RDP-Zugriff auf die öffentliche IP-Adresse des Administrators beschränkt
* Netzwerkzugriff über Security Rules kontrolliert

### 📸 Screenshot 04 — Network Security Group

![Network Security Group](./images/04-nsg.png)

### 📸 Screenshot 05 — NSG Inbound Rules

![NSG Inbound Rules](./images/05-nsg-rules.png)

---

## 3. 🖥️ Windows Server Virtual Machine

Eine Windows Server Virtual Machine wurde innerhalb des Azure Virtual Networks bereitgestellt.

### Konfiguration

| Ressource         | Konfiguration                                 |
| ----------------- | --------------------------------------------- |
| VM Name           | `vm-web-01`                                   |
| Betriebssystem    | Windows Server 2022 Datacenter: Azure Edition |
| Größe             | `B2als_v2`                                    |
| Availability Zone | Zone 1                                        |
| Private IP        | `10.0.1.4`                                    |
| Sicherheit        | Trusted Launch                                |

Die VM wird verwendet, um Netzwerkverbindungen, Azure-Dienste, Identity und Storage-Zugriffe zu testen.

### 📸 Screenshot 06 — Virtual Machine Übersicht

![Virtual Machine](./images/06-vm-overview.png)

### 📸 Screenshot 07 — VM Networking

![VM Networking](./images/07-vm-networking.png)

---

## 4. 🛣️ Routing

Custom Routing wurde konfiguriert, um den Netzwerkverkehr und das Verhalten von Next Hops in Azure zu demonstrieren.

### Konfiguration

| Einstellung      | Wert        |
| ---------------- | ----------- |
| Route            | `0.0.0.0/0` |
| Next Hop Type    | Internet    |
| Next Hop Address | `10.0.1.10` |

Die Routing-Konfiguration wurde im Rahmen des Netzwerk-Labors und der Troubleshooting-Szenarien verwendet.

### 📸 Screenshot 08 — Route Table

![Route Table](./images/08-route-table.png)

### 📸 Screenshot 09 — Route Configuration

![Route Configuration](./images/09-route.png)

---

## 5. 📦 Azure Storage

Ein Azure Storage Account wurde bereitgestellt und für Tests des sicheren Zugriffs von der Azure Virtual Machine verwendet.

Die Storage-Umgebung umfasst Blob Storage und private Konnektivität.

### 📸 Screenshot 10 — Storage Account

![Storage Account](./images/10-storage-account.png)

### 📸 Screenshot 11 — Blob Storage

![Blob Storage](./images/11-blob-storage.png)

---

## 6. 🔗 Private Endpoint & Private DNS

Ein Private Endpoint wurde konfiguriert, um eine private Netzwerkverbindung zu Azure Blob Storage bereitzustellen.

### Konfiguration

| Ressource        | Konfiguration                       |
| ---------------- | ----------------------------------- |
| Private Endpoint | `pe-storage-01`                     |
| Ziel             | Azure Storage Blob                  |
| Private IP       | `10.0.1.5`                          |
| Private DNS Zone | `privatelink.blob.core.windows.net` |

Diese Konfiguration demonstriert den privaten Zugriff auf einen Azure-PaaS-Dienst, ohne einen öffentlichen Endpoint zu verwenden.

### 📸 Screenshot 12 — Private Endpoint

![Private Endpoint](./images/12-private-endpoint.png)

### 📸 Screenshot 13 — Private DNS Zone

![Private DNS](./images/13-private-dns.png)

---

## 7. 🆔 Managed Identity & RBAC

Eine Managed Identity wurde verwendet, um der Virtual Machine kontrollierten Zugriff auf Azure-Ressourcen zu ermöglichen, ohne Anmeldeinformationen direkt auf der VM speichern zu müssen.

Der VM-Identity wurde die erforderliche Azure-RBAC-Berechtigung für den Zugriff auf Blob Storage zugewiesen.

### Role Assignment

* Managed Identity
* Azure Storage
* `Storage Blob Data Reader`

### 📸 Screenshot 14 — Managed Identity

![Managed Identity](./images/14-managed-identity.png)

### 📸 Screenshot 15 — Role Assignment

![Role Assignment](./images/15-role-assignment.png)

---

## 8. 💻 Azure CLI

Azure CLI wurde verwendet, um Azure-Ressourcen aus der Windows-Server-Umgebung zu verwalten und zu testen.

Das Labor umfasst die Authentifizierung und Interaktion mit Azure-Ressourcen über Azure CLI.

### 📸 Screenshot 16 — Azure CLI

![Azure CLI](./images/16-azure-cli.png)

### 📸 Screenshot 17 — Azure CLI Identity / Resource Test

![Azure CLI Test](./images/17-azure-cli-test.png)

---

## 9. 🧪 Testing & Troubleshooting

Die Umgebung wurde durch praktische Troubleshooting-Szenarien getestet.

Die Tests umfassten:

* Netzwerk-Konnektivität
* Kommunikation über private IP-Adressen
* Überprüfung von NSG-Regeln
* Überprüfung des Routings
* Private Endpoint-Konnektivität
* Private DNS-Auflösung
* Managed-Identity-Authentifizierung
* Zugriff auf Azure Storage
* Azure CLI-Authentifizierung

Das Troubleshooting erfolgte durch die Überprüfung von Azure Networking, Security Rules, Routing, DNS, Identity und Resource Configuration.

### 📸 Screenshot 18 — Netzwerk-Konnektivitätstest

![Network Connectivity Test](./images/18-connectivity-test.png)

### 📸 Screenshot 19 — DNS-Auflösungstest

![DNS Resolution Test](./images/19-dns-test.png)

### 📸 Screenshot 20 — Storage-Zugriffstest

![Storage Access Test](./images/20-storage-test.png)

---

## 🛠️ Technologien

**Cloud**

Azure

**Infrastruktur**

Azure Virtual Network · Virtual Machines · Azure Storage

**Networking**

VNet · Subnetze · Routing · NSGs · Private Endpoints · Private DNS

**Identity**

Managed Identity · Azure RBAC

**Betriebssysteme**

Windows Server 2022

**Automation / Administration**

Azure CLI · PowerShell

---

## 📚 Nachgewiesene Kenntnisse

* Bereitstellung von Azure-Infrastrukturen
* Virtuelles Networking
* Subnetzdesign
* Netzwerksicherheit
* Routing
* Windows Server Administration
* Azure Storage
* Konfiguration von Private Endpoints
* Private DNS
* Managed Identity
* RBAC
* Azure CLI
* Netzwerk-Troubleshooting
* Cloud-Infrastruktur-Troubleshooting

---

## 🚀 Nächste Schritte

Geplante Erweiterungen des Azure-Labors:

* Azure Active Directory / Microsoft Entra ID Integration
* Hybrid Identity mit lokalem Active Directory
* Erweiterung der Azure-Netzwerkinfrastruktur
* Azure Monitoring
* Infrastructure as Code mit Terraform
* AWS + Azure Hybrid Connectivity

---

## 📌 Projektstatus

Dieses Labor ist ein fortlaufendes praktisches Cloud-Infrastrukturprojekt.

Die Umgebung wird kontinuierlich um neue Azure-Dienste, Networking-Szenarien, Automatisierung und Troubleshooting-Übungen erweitert.
