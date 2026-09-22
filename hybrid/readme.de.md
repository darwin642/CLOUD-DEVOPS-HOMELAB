# 🔗 Hybrid Cloud Lab

Ein praktisches Hybrid-Cloud-Labor, das **Microsoft Azure, Amazon Web Services, Google Cloud Platform und eine On-Premises Active-Directory-Umgebung** miteinander verbindet.

Ziel des Projekts ist es, Cloud-Plattformen mit einer bestehenden **On-Premises-Infrastruktur** zu verbinden und praktische Szenarien für **hybride Konnektivität, hybride Identität und Kommunikation zwischen verschiedenen Umgebungen** zu demonstrieren.

---

## 📌 Projektübersicht

Das Projekt umfasst folgende Umgebungen und Technologien:

* Microsoft Azure
* Amazon Web Services
* Google Cloud Platform
* On-Premises Active Directory
* Tailscale
* Hybrid Identity
* DNS
* Network Connectivity

Die vier Umgebungen können über das hybride Netzwerk miteinander kommunizieren.

Die wichtigste hybride Integration innerhalb der Umgebung besteht zwischen **On-Premises Active Directory und Microsoft Azure**.

Die AWS- und Google-Cloud-Platform-Umgebungen werden als separate Cloud-Infrastrukturen betrieben, nehmen jedoch über Tailscale am gesamten hybriden Netzwerk teil.

---

## 🏗️ Architektur

![Tailscale Connectivity](hybrid-diagram.png)

Die Architektur besteht aus vier Hauptumgebungen:

* ☁️ Microsoft Azure
* ☁️ Amazon Web Services
* ☁️ Google Cloud Platform
* 🪟 On-Premises Active Directory

Alle vier Umgebungen sind über **Tailscale** miteinander verbunden. Dadurch wird die Netzwerkkommunikation zwischen den verschiedenen Infrastrukturumgebungen ermöglicht.

Die primäre Hybrid-Identity-Verbindung besteht zwischen **On-Premises Active Directory und Azure** und verwendet Azure AD Connect.

---

## 1. 🔗 Hybride Konnektivität — Tailscale

**Tailscale stellt die Netzwerk-Konnektivitätsschicht zwischen den On-Premises-, Azure-, GCP- und AWS-Umgebungen bereit.**

Anstatt separate VPN-Verbindungen zwischen jeder Umgebung aufzubauen, stellt Tailscale ein gemeinsames privates Netzwerk bereit, über das Systeme aus verschiedenen Infrastrukturumgebungen miteinander kommunizieren können.

### Konnektivität

```text
                        HYBRID NETWORK
                              │
                       ┌──────▼──────┐
                       │  Tailscale  │
                       │ Private VPN │
                       └──────┬──────┘
                              │
       ┌──────────────┬──────────────┬────────────┐
       │              │              │            │
       ▼              ▼              ▼            ▼
ON-PREMISES         AZURE           AWS          GCP
Active Directory    VNet            VPC          VPC
Windows Server      Azure VM        EC2         GCP VM
```

Tailscale wird als **Netzwerk-Konnektivitätsschicht** verwendet, während die eigentlichen Dienste und Identitäten von den jeweiligen Plattformen verwaltet werden.

Dadurch können Systeme aus den drei Cloud-Umgebungen und der On-Premises-Infrastruktur über private Netzwerkverbindungen miteinander kommunizieren.

### Abgedeckte Bereiche

* Private network connectivity
* Cross-environment communication
* On-Premises → Azure Verbindung
* On-Premises → AWS Verbindung
* On-Premises → GCP Verbindung
* Azure → AWS Verbindung
* GCP → AWS Verbindung
* Tailscale subnet routing
* Hybrid network communication

Zum Beispiel kann von unserem On-Premises-Windows-Server **HL-DC01** auf die AWS-virtuelle Maschine **WEB01** zugegriffen werden.

### 📸 Screenshot — Tailscale Connectivity

![Tailscale Connectivity](tailscale-connectivity.png)

---

## 2. 🪟🔗☁️ On-Premises Active Directory ↔ Azure

Dies ist die **wichtigste hybride Integration** innerhalb des Projekts.

Die On-Premises-Windows-Server-Umgebung stellt die Active-Directory-Infrastruktur bereit, während Microsoft Azure die Cloud-Identity- und Infrastrukturkomponenten bereitstellt.

Die beiden Umgebungen sind sowohl über:

* **Netzwerk-Konnektivität über Tailscale**
* **Identitätssynchronisierung über Azure AD Connect**

miteinander verbunden.

Dadurch entsteht eine praktische **Hybrid-Identity-Umgebung**, in der Benutzeridentitäten aus dem On-Premises Active Directory mit Azure synchronisiert werden können.

### Hybrid-Identity-Ablauf

```text
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
```

Azure AD Connect synchronisiert Identitäten zwischen der On-Premises-Active-Directory-Umgebung und Azure.

Dies demonstriert, wie eine bestehende On-Premises-Active-Directory-Infrastruktur erhalten und gleichzeitig die Identity-Umgebung in die Cloud erweitert werden kann.

### Hybrid-Komponenten

* On-Premises Active Directory
* Windows Server Domain Controller
* Azure AD Connect
* Azure Identity
* User synchronization
* Tailscale network connectivity

### 📸 Screenshot 01 — Azure AD Connect

![Azure AD Connect](azure-ad-connect2.png)

### 📸 Screenshot 02 — Synchronization

![Synchronization](azure-ad-sync.png)

---

## 3. ☁️ Microsoft Azure

Azure ist eine der wichtigsten Cloud-Plattformen innerhalb der hybriden Infrastruktur.

Die Azure-Umgebung umfasst:

* Virtual Network
* Subnets
* Windows Server
* Private Endpoint
* Private DNS
* Managed Identity

Die Azure-Umgebung ist über Tailscale mit der On-Premises-Infrastruktur verbunden.

Azure nimmt außerdem durch die Integration mit der On-Premises-Active-Directory-Umgebung an der Hybrid-Identity-Architektur teil.

### 📸 Screenshot — Azure Connectivity

![Azure Connectivity](azure-connectivity.png)

---

## 4. ☁️ Amazon Web Services

AWS ist die zweite Cloud-Plattform innerhalb des Hybrid-Cloud-Portfolios.

Die AWS-Umgebung umfasst:

* VPC
* Public and private subnets
* EC2
* Security Groups
* Application Load Balancer

Die AWS-Infrastruktur wird als separate Cloud-Umgebung betrieben und mit Terraform verwaltet.

AWS ist über das gemeinsame Tailscale-Netzwerk mit den On-Premises- und Azure-Umgebungen verbunden.

Dadurch kann AWS am gesamten hybriden Netzwerk teilnehmen, ohne Teil der Active-Directory-Identity-Synchronisierung zu sein.

### 📸 Screenshot — AWS Connectivity

![AWS Connectivity](aws-connectivity.png)

---

## 5. 🪟 On-Premises Active Directory

Die On-Premises-Umgebung basiert auf Windows Server und stellt die zentrale Identity- und Windows-Infrastruktur des Unternehmens bereit.

Die Umgebung umfasst:

* Active Directory Domain Services
* DNS
* DHCP
* Group Policy
* File Sharing
* Windows clients

Die Active-Directory-Umgebung ist über **Azure AD Connect** mit Azure integriert.

Benutzeridentitäten werden zwischen dem On-Premises Active Directory und Azure synchronisiert.

Die On-Premises-Umgebung nimmt außerdem über Tailscale am hybriden Netzwerk teil.

---

## 6. ☁️ Google Cloud Platform

GCP ist eine weitere Cloud-Plattform innerhalb des Hybrid-Cloud-Portfolios.

Die GCP-Umgebung umfasst:

* VPC
* Public and private subnets
* Compute Engine
* Global External Application Load Balancer
* Managed Instance Group
* Cloud Storage

Die GCP-Infrastruktur wird als separate Cloud-Umgebung betrieben und über **Tailscale mit den On-Premises- und AWS-Umgebungen verbunden**.

GCP stellt Netzwerk-Konnektivität zu diesen Umgebungen bereit, nimmt jedoch nicht an der Active-Directory-Identity-Synchronisierung teil.

### 📸 Screenshot — GCP Connectivity

![GCP Connectivity](gcp-connectivity.png)

---

## 7. 🌐 Hybride Kommunikation

Die vier Umgebungen kommunizieren über das Tailscale-Netzwerk:

```text
                 ┌─────────────────────┐
                 │      TAILSCALE      │
                 │ Hybrid Connectivity │
                 └──────────┬──────────┘
                            │
     ┌──────────────────────┼───────────────────────────────────┐
     │                      │                                   │
     ▼                      ▼                                   ▼
┌─────────────┐      ┌─────────────┐      ┌─────────────┐   ┌─────────────┐
│ ON-PREMISES │      │    AZURE    │      │     AWS     │   │     GCP     │
│             │      │             │      │             │   │             │
│ HL-DC01     │◄────►│ Azure VNet  │◄────►│ AWS VPC     │◄─►│ GCP VPC     │
│ AD DS       │      │ Azure VM    │      │ EC2         │   │ Compute     │
│ DNS / DHCP  │      │             │      │ ALB         │   │ Global LB   │
└──────┬──────┘      └─────────────┘      └─────────────┘   │ Cloud       │
       │                                                    │ Storage     │
       │                                                    └─────────────┘
       │
       │ Azure AD Connect
       ▼
┌─────────────────┐
│ Azure Identity  │
│ Hybrid Identity │
└─────────────────┘
```

Die wichtige Unterscheidung besteht darin, dass **Tailscale Netzwerk-Konnektivität** bereitstellt, während **Azure AD Connect die Identitätssynchronisierung** übernimmt.

Daher:

**Tailscale = Network Connectivity**

**Azure AD Connect = Hybrid Identity**

Durch diese Trennung kann das Labor sowohl **hybride Netzwerke** als auch **hybride Identitäten** innerhalb derselben Umgebung demonstrieren.

---

## 📌 Fokus des Hybrid-Labs

Dieses Projekt demonstriert eine praktische Hybrid-Infrastruktur, die **On-Premises Active Directory, Microsoft Azure, GCP und AWS** miteinander verbindet.

Die wichtigste hybride Integration besteht zwischen **On-Premises Active Directory und Azure**, wobei Azure AD Connect die Identitätssynchronisierung übernimmt.

Auf Netzwerkebene verbindet **Tailscale alle vier Umgebungen**, sodass On-Premises-, Azure-, GCP- und AWS-Systeme miteinander kommunizieren können.

Das Projekt demonstriert daher:

* Hybrid networking
* Hybrid identity
* Active Directory integration with Azure
* Azure AD Connect
* Cross-cloud connectivity
* On-Premises to cloud communication
* Azure to AWS communication
* GCP to AWS communication
* AWS to On-Premises communication
* GCP to On-Premises communication
* Tailscale-based private connectivity
