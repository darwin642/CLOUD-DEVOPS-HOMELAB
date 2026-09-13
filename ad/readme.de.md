# 🪟 Active Directory Lab

Eine praktische **On-Premises-Active-Directory-Umgebung**, die mit Windows Server als Teil meines Cloud-&-DevOps-Homelabs aufgebaut wurde.

Für dieses Lab habe ich eine fiktive **Videobearbeitungsagentur** mit drei Abteilungen erstellt:

* 👥 **Personalabteilung (Human Resources)**
* 🎬 **Videobearbeitung (Video Editing)**
* 💻 **IT**

Jede Abteilung verfügt über ein eigenes Benutzerkonto und ein eigenes **gemapptes Netzlaufwerk**.

Die Abteilungslaufwerke werden auf dem Windows Server gehostet. Die Benutzer greifen über den Server auf ihr zugewiesenes Laufwerk zu. Dadurch fungiert der **Server als Endpunkt für den Netzwerkdateiverkehr der jeweiligen Abteilung**.

Die Umgebung wurde entwickelt, um zu zeigen, wie ein kleines Unternehmen **Benutzer, Computer, Netzwerkdienste, Dateizugriff, Sicherheitsrichtlinien und Windows-Clients** mithilfe von Active Directory zentral verwalten kann.

> **📌 Hinweis:**
> Die ausführlichere Version dieses Labs findest du auf meinem GitHub-Profil unter **`hugehomelab`**.
> Leider kann ich derzeit keine zusätzlichen Screenshots von den Client-Computern bereitstellen. Aufgrund eines Festplattenschadens habe ich keinen Zugriff mehr auf die in diesem Lab verwendeten Client-Systeme. Der Windows Server ist weiterhin zugänglich, daher konzentrieren sich die verfügbaren Screenshots hauptsächlich auf die serverseitige Konfiguration und Administration.

---

## 🏗️ Architektur

![Active Directory Architecture](ad_diagram.jpg)

> On-Premises-Netzwerk mit dem Windows Server Domain Controller, Active Directory, DNS, DHCP, Group Policy, gemeinsam genutzten Netzlaufwerken und domänengebundenen Clients.

---

## 🏢 Active Directory Domain Services

Der Windows Server ist als **Active Directory Domain Controller** konfiguriert und stellt eine zentrale Verwa
