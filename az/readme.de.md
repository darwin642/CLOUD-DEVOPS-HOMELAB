# ☁️ Microsoft Azure Infrastructure Lab

Praktisches Azure-Infrastrukturlabor zur Entwicklung praxisnaher Kenntnisse in den Bereichen Cloud-Infrastruktur, Netzwerke, Sicherheit, Identität, Storage und Systemadministration.

Der Schwerpunkt des Labs liegt auf dem Entwurf, der Konfiguration, dem Testen, der Fehlerbehebung und der Verwaltung von Azure-Ressourcen in einer realistischen Infrastrukturumgebung.

---

## 📌 Projektübersicht

Dieses Labor umfasst die Bereitstellung und Konfiguration einer kleinen Azure-Infrastrukturumgebung.

Das Projekt beinhaltet:

* Azure Virtual Network
* Subnetze
* Network Security Groups
* Netzwerk-Routing
* Linux Virtual Machine
* Azure Storage
* Private Endpoint
* Private DNS
* Managed Identity
* Azure CLI
* Role-Based Access Control
* Azure Backup
* Management Locks
* Netzwerk-Fehlerbehebung

---

## 🏗️ Architektur

### Architekturdiagramm

Die Umgebung enthält ein Azure Virtual Network mit einer strukturierten Subnetzarchitektur, Netzwerk-Sicherheitskontrollen, einer Linux Virtual Machine und einer privaten Verbindung zu Azure Storage.

---

## 1. 🌐 Virtual Network & Subnetze

Die Azure-Netzwerkumgebung wurde mithilfe eines dedizierten Virtual Networks und einer strukturierten Subnetzarchitektur erstellt.

### Konfiguration

| Ressource       | Konfiguration     |
| --------------- | ----------------- |
| Resource Group  | `rg-az104-lab01`  |
| Virtual Network | `vnet-az104-tf01` |
| Address Space   | `10.10.0.0/16`    |
| Subnetz         | `WebSubnet`       |
| Subnetzbereich  | `10.10.1.0/24`    |
| Region          | Sweden Central    |

### 📸 Screenshot 01 — Resource Group

### 📸 Screenshot 02 — Virtual Network

### 📸 Screenshot 03 — Subnetzkonfiguration

---

## 2. 🔐 Netzwerksicherheit

Der Netzwerkverkehr wurde mithilfe von Network Security Groups kontrolliert.

Eine NSG wurde dem WebSubnet zugeordnet, um den eingehenden und ausgehenden Netzwerkverkehr zu kontrollieren.

### Konfiguration

* Network Security Group: `nsg-web-tf01`
* Subnetzzuordnung: `WebSubnet`
* RDP-Zugriff wird über Sicherheitsregeln kontrolliert
* HTTP-Zugriff wird über Sicherheitsregeln kontrolliert
* Netzwerkzugriff wird über NSG-Regeln kontrolliert

### 📸 Screenshot 04 — Network Security Group

### 📸 Screenshot 05 — Eingehende NSG-Regeln

---

## 3. 🖥️ Linux Virtual Machine

Eine Linux Virtual Machine wurde innerhalb des Azure Virtual Networks bereitgestellt.

### Konfiguration

| Ressource        | Konfiguration       |
| ---------------- | ------------------- |
| VM-Name          | `vm-web-tf01`       |
| Betriebssystem   | Ubuntu 24.04 LTS    |
| Größe            | `Standard_B2ats_v2` |
| Private IP       | `10.10.1.4`         |
| Managed Identity | System-assigned     |

Die VM wurde verwendet, um Netzwerkverbindungen, Azure-Dienste, Identität, private DNS-Auflösung und den Zugriff auf Storage zu testen.

### 📸 Screenshot 06 — Übersicht der Virtual Machine

### 📸 Screenshot 07 — VM-Netzwerk

---

## 4. 🛣️ Routing

Ein benutzerdefiniertes Routing wurde konfiguriert, um den Azure-Netzwerkverkehr und das Verhalten des nächsten Hops zu demonstrieren.

### Konfiguration

| Einstellung   | Wert        |
| ------------- | ----------- |
| Route         | `0.0.0.0/0` |
| Next Hop Type | Internet    |

Die Routing-Konfiguration wurde im Rahmen des Netzwerk-Labors und der praktischen Fehlerbehebung verwendet.

### 📸 Screenshot 08 — Route Table

### 📸 Screenshot 09 — Routenkonfiguration

---

## 5. 📦 Azure Storage

Ein Azure Storage Account wurde bereitgestellt und verwendet, um den sicheren Zugriff von der Azure Virtual Machine zu testen.

Die Storage-Umgebung umfasst Blob Storage, Blob-Versionierung, Soft-Delete-Aufbewahrung und private Konnektivität.

### 📸 Screenshot 10 — Storage Account

### 📸 Screenshot 11 — Blob Storage

---

## 6. 🔗 Private Endpoint & Private DNS

Ein Private Endpoint wurde konfiguriert, um eine private Netzwerkverbindung zu Azure Blob Storage bereitzustellen.

### Konfiguration

| Ressource        | Konfiguration                       |
| ---------------- | ----------------------------------- |
| Private Endpoint | `pe-storage-tf01`                   |
| Ziel             | Azure Storage Blob                  |
| Private IP       | `10.10.1.5`                         |
| Private DNS Zone | `privatelink.blob.core.windows.net` |

Die Private DNS Zone wird zentral in der Resource Group `rg-network-prod` verwaltet und ist mit dem Lab-Virtual-Network verknüpft.

Diese Konfiguration demonstriert den privaten Zugriff auf Azure-PaaS-Dienste, ohne auf einen öffentlichen Endpoint angewiesen zu sein.

### 📸 Screenshot 12 — Private Endpoint

### 📸 Screenshot 13 — Private DNS Zone

---

## 7. 🆔 Managed Identity & RBAC

Eine systemseitig zugewiesene Managed Identity wurde verwendet, um der Virtual Machine kontrollierten Zugriff auf Azure-Ressourcen zu ermöglichen, ohne Anmeldeinformationen direkt auf der VM speichern zu müssen.

Der VM-Identität wurde die erforderliche Azure-RBAC-Berechtigung für den Zugriff auf Blob Storage zugewiesen.

### Rollenzuweisung

* System-assigned Managed Identity
* Azure Storage
* `Storage Blob Data Reader`

Das Lab enthält außerdem eine `Resource Group Reader`-Rollenzuweisung für die konfigurierte Azure AD / Microsoft Entra-Gruppe.

### 📸 Screenshot 14 — Managed Identity

### 📸 Screenshot 15 — Rollenzuweisung

---

## 8. 🔒 Management Lock & Backup

Ein Resource Lock wurde konfiguriert, um das versehentliche Löschen der Lab-Resource-Group zu verhindern.

### Konfiguration

* Management Lock: `lock-az104-tf01`
* Lock Type: `CanNotDelete`

Azure Backup wurde ebenfalls für die Virtual Machine konfiguriert und der Backup-Status erfolgreich überprüft.

### 📸 Screenshot 16 — Management Lock

### 📸 Screenshot 17 — Backup / Recovery

---

## 9. 🧪 Testen & Fehlerbehebung

Die Umgebung wurde anhand praktischer Troubleshooting-Szenarien getestet.

Die Tests umfassten:

* Netzwerkverbindungen
* Kommunikation über private IP-Adressen
* Validierung der NSG-Regeln
* Validierung des Routings
* Private-Endpoint-Konnektivität
* Private-DNS-Auflösung
* Authentifizierung über Managed Identity
* Zugriff auf Azure Storage
* Validierung von Azure Backup
* Validierung des Management Locks

Die private DNS-Auflösung wurde direkt von der Ubuntu-VM mithilfe von `nslookup` getestet.

Der Storage-Account-Endpoint wurde über den Private-Link-DNS-Namespace zur privaten IP-Adresse des Private Endpoints aufgelöst.

```text
az104tflab3531.blob.core.windows.net
        ↓
az104tflab3531.privatelink.blob.core.windows.net
        ↓
10.10.1.5
```

Anschließend wurde der Storage-Zugriff von der VM mithilfe ihrer systemseitig zugewiesenen Managed Identity getestet.

```bash
az login --identity

az storage blob list \
  --account-name az104tflab3531 \
  --container-name lab-data \
  --auth-mode login \
  -o table
```

Der Befehl gab erfolgreich das im Container `lab-data` gespeicherte Blob zurück.

### 📸 Screenshot 18 — SSH-Verbindungstest

![Storage Access Test](18-connectivity-test.png)

### 📸 Screenshot 19 — Private-DNS-Auflösung

![Storage Access Test](18-dns-test.png)

### 📸 Screenshot 20 — Storage-Zugriffstest

![Storage Access Test](19-storage-test.png)

---

## 🛠️ Technologien

**Cloud**

Azure

**Infrastruktur**

Azure Virtual Network · Virtual Machines · Azure Storage · Azure Backup

**Netzwerk**

VNet · Subnetze · Routing · NSGs · Private Endpoints · Private DNS

**Identität**

Managed Identity · Azure RBAC · Microsoft Entra ID

**Betriebssysteme**

Ubuntu 24.04 LTS

**Automation / Administration**

Azure CLI · PowerShell · Terraform

---

## 📚 Nachgewiesene Kenntnisse

* Bereitstellung von Azure-Infrastrukturen
* Virtuelle Netzwerke
* Subnetzdesign
* Netzwerksicherheit
* Routing
* Linux / Ubuntu VM-Administration
* Azure Storage
* Konfiguration von Private Endpoints
* Private DNS
* Managed Identity
* RBAC
* Microsoft Entra ID
* Azure Backup
* Management Locks
* Azure CLI
* Terraform
* Netzwerk-Troubleshooting
* Cloud-Infrastruktur-Troubleshooting

---

## 🚀 Nächste Schritte

Geplante Erweiterungen des Azure-Labors:

* Integration von Azure Active Directory / Microsoft Entra ID
* Hybride Identität mit lokalem Active Directory
* Erweiterung der Azure-Netzwerkinfrastruktur
* Azure Monitoring
* Erweiterte Infrastructure as Code mit Terraform
* AWS + Azure Hybrid Connectivity

---

## 📌 Projektstatus

Dieses Labor ist ein fortlaufendes praktisches Cloud-Infrastrukturprojekt.

Die Umgebung wird kontinuierlich um neue Azure-Dienste, Netzwerkszenarien, Automatisierung, Infrastructure as Code und Troubleshooting-Szenarien erweitert.
