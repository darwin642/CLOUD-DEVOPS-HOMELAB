# ☁️ Ehrliche Bewertung — Azure vs AWS vs GCP

> Ein persönlicher, praxisorientierter Vergleich der drei Cloud-Plattformen, mit denen ich während meiner Cloud- und DevOps-Lernreise gearbeitet habe.

Diese Seite dokumentiert meine Erfahrungen mit **Microsoft Azure, Amazon Web Services (AWS) und Google Cloud Platform (GCP)** beim Aufbau, bei der Konfiguration, Fehlerbehebung und Verwaltung von Infrastruktur.

Der Vergleich basiert auf meinen eigenen praktischen Erfahrungen und nicht auf theoretischen Benchmarks oder Marketingmaterialien.

> [!WARNING]
> Wenn du auf dieser Seite bist, hast du entweder meine Dokumentation vollständig gelesen oder bist versehentlich hier gelandet. Wenn du nicht weißt, worum es hier geht, bitte ich dich, zurückzugehen. Dies ist die abschließende Meinungsseite; hier gibt es nichts zu lernen.

---

# 🎯 Warum ich den Cloud-/DevOps-Weg gewählt habe

Meine Entscheidung, mich in Richtung **Cloud und DevOps** zu entwickeln, wurde sowohl durch berufliche Möglichkeiten als auch durch mein Interesse an größeren Infrastrukturen beeinflusst.

Die Möglichkeiten im klassischen IT-Bereich sind in meinem Land relativ begrenzt, und ich wollte mich über den traditionellen IT-Support hinausentwickeln.

Mein IT-Hintergrund gab mir eine Grundlage in:

* Troubleshooting
* Betriebssystemen
* Benutzersupport
* Hardware
* Networking
* Technischer Problemlösung

Ich wollte jedoch mit **größeren Systemen und Infrastrukturen** arbeiten.

Daher wandte ich mich folgenden Bereichen zu:

* ☁️ Cloud Infrastructure
* 🌐 Networking
* 🔐 Identity and Access Management
* ⚙️ Automation
* 🧱 Infrastructure as Code
* 📊 Monitoring
* ♻️ High Availability
* 📈 Scalability
* 📦 Containers
* 🔄 DevOps workflows

Mein Ziel war nicht einfach, Zertifikate zu sammeln.

Ich wollte Infrastruktur verstehen, indem ich:

```text
Build
  ↓
Configure
  ↓
Break
  ↓
Troubleshoot
  ↓
Fix
  ↓
Destroy
  ↓
Rebuild
```

---

# ☁️ Wo mein Cloud-Lernen begann

Mein strukturiertes Cloud-Lernen begann mit **Microsoft Azure**.

Ich begann im **August 2026**, Cloud-Infrastruktur anhand des **AZ-104-Lehrplans** zu lernen.

Der AZ-104-Lehrplan wurde zur strukturierten Grundlage meiner Kenntnisse in der Cloud-Administration. Er gab mir einen praktischen Rahmen zum Verständnis von:

* Azure Virtual Networks
* Subnets und IP-Adressierung
* Network Security
* Virtual Machines
* Storage
* Identity und RBAC
* Monitoring
* Backup
* High Availability
* Governance
* Security

> **Wichtig:** Dies bedeutet nicht, dass ich die AZ-104-Zertifizierung erworben habe. Der AZ-104-Lehrplan war der strukturierte Lernpfad, den ich zum Aufbau meiner ersten Kenntnisse in der Cloud-Administration verwendet habe.

**Microsoft Learn** war während dieser ersten Azure-Phase meine wichtigste technische Lernquelle.

---

## 🗺️ Mein erster Lernplan

Zu Beginn meiner Cloud-Reise benötigte ich eine strukturierte Methode, um zu verstehen, **was ich lernen sollte, in welcher Reihenfolge ich lernen sollte und wie ich theoretisches Wissen in praktische Erfahrung umwandeln konnte**.

Der folgende Screenshot zeigt meinen ursprünglichen Cloud-Lernplan und meinen damaligen Lernansatz.

![Cloud learning roadmap](startfinish.png)

---

# 🧪 Wie ich gelernt habe

Mein Lernprozess war hauptsächlich **praxis- und experimentorientiert**.

Ich verwendete:

* Microsoft Learn
* Offizielle Cloud-Dokumentation
* ChatGPT
* Google Gemini
* Microsoft Copilot
* YouTube
* Meine eigenen Home-Labs

KI-Tools verwendete ich als **interaktive Lernhilfen** und nicht einfach als Quellen zum Kopieren von Konfigurationen.

Mein typischer Lernzyklus sah so aus:

```text
Learn
   │
   ▼
Build
   │
   ▼
Configure
   │
   ▼
Test
   │
   ▼
Break
   │
   ▼
Troubleshoot
   │
   ▼
Fix
   │
   ▼
Destroy
   │
   ▼
Rebuild
   │
   ▼
Document
```

Ich erstellte bewusst Infrastrukturen, änderte Konfigurationen, erzeugte Probleme, untersuchte Fehler, behob sie, löschte Umgebungen und baute sie anschließend wieder auf.

Dadurch konnte ich nicht nur verstehen, **wie etwas funktioniert**, sondern auch **warum es funktioniert und was passiert, wenn es nicht funktioniert**.

---

# ☁️ Azure → AWS → GCP

Nachdem ich mit Azure und dem AZ-104-Lehrplan meine ersten Grundlagen aufgebaut hatte, erweiterte ich mein Lernen auf **AWS** und später auf **GCP**.

Das Ziel war, zu verstehen, wie allgemeine Infrastrukturkonzepte in verschiedenen Cloud-Ökosystemen umgesetzt werden.

Mein Lernweg entwickelte sich ungefähr wie folgt:

```text
AZ-104 Curriculum
        │
        ▼
Microsoft Azure
        │
        ▼
AWS
        │
        ▼
GCP
        │
        ▼
Terraform / Infrastructure as Code
        │
        ▼
Docker / DevOps Workflows
```

Ich wollte sehen, welche Konzepte zwischen den Plattformen gleich bleiben und an welchen Stellen die Plattformen dieselben Probleme unterschiedlich lösen.

---

# 🟦 Microsoft Azure

Mein Cloud-Lernen begann mit Azure.

Meine praktische Arbeit mit Azure umfasste:

* Virtual Networks
* Subnets
* Network Security Groups
* Virtual Machines
* Routing
* Storage
* Private Endpoints
* Managed Identities
* RBAC
* Monitoring
* Backup
* Azure CLI
* Windows Server
* Hybrid connectivity

Azure war auch die Plattform, über die ich erstmals ein strukturiertes Verständnis für Cloud-Administration entwickelte.

---

# 🟧 Amazon Web Services

Nach Azure erweiterte ich mein Wissen auf AWS, um vergleichbare Infrastrukturkonzepte in einem anderen großen Cloud-Ökosystem zu verstehen.

Meine AWS-Arbeit umfasste:

* VPC
* Public and private subnets
* Internet Gateway
* Route Tables
* EC2
* Application Load Balancer
* Security Groups
* IAM
* Systems Manager
* VPC Endpoints
* CloudWatch
* SNS
* S3
* Backup
* Multi-AZ architecture
* Terraform

Die Arbeit mit AWS ermöglichte mir den Vergleich von Konzepten wie:

* Azure VNets vs AWS VPCs
* Azure RBAC vs AWS IAM
* Azure Load Balancing vs AWS load balancing services

---

# 🟨 Google Cloud Platform

GCP wurde später hinzugefügt, um den Vergleich über Azure und AWS hinaus zu erweitern.

Meine GCP-Arbeit umfasste:

* VPC
* Public and private subnets
* Compute Engine
* Global Application Load Balancer
* Managed Instance Groups
* Autoscaling
* Cloud Storage
* Lifecycle Management
* IAM
* Service Accounts
* Cloud DNS
* Private Google Access
* Cloud Monitoring
* Alerting
* Backup and Disaster Recovery
* Private connectivity

Dadurch erhielt ich eine weitere Perspektive darauf, wie Networking, Compute, Identity, Load Balancing und Monitoring in einer Cloud-Umgebung umgesetzt werden.

---

# ⚖️ Azure vs AWS vs GCP — Praktischer Vergleich

Dies ist der zentrale und **schonungslose Vergleich** dieser Seite.

Das Ziel ist **keine objektive Rangliste der Branche**.

Stattdessen vergleiche ich die Plattformen auf Grundlage meiner persönlichen Erfahrungen mit:

* Consoles
* CLI tools
* Networking systems
* IAM models
* Monitoring tools
* Documentation
* Troubleshooting workflows

Der Vergleich konzentriert sich auf:

|  # | Bereich                      |
| -: | ---------------------------- |
| 01 | 🖥️ GUI / Console Experience |
| 02 | 🧭 Navigation                |
| 03 | 📚 Documentation             |
| 04 | 💻 CLI Experience            |
| 05 | 🌐 Network Management        |
| 06 | 🔐 IAM & Authorization       |
| 07 | 📊 Monitoring                |
| 08 | 🛠️ Troubleshooting          |
| 09 | 📈 Learning Curve            |
| 10 | 👤 Overall User Experience   |
| 11 | 🤖 AI-Assisted Experience    |

---

# 🖥️ GUI-/Console-Erfahrung

## 🟦 Azure

**Meine Erfahrung:**

> Es ist die beste Benutzeroberfläche, die ich bisher gesehen habe. Sie zeigt direkt, was man zum Erstellen einer Umgebung benötigt. Man kann Themes auswählen. Man kann jede Umgebung ohne Verwirrung auswählen. 10/10

## 🟧 AWS

**Meine Erfahrung:**

> Bei der Erstellung einer neuen Entity wird der Name nicht automatisch übernommen; selbst wenn man ihn eingibt, muss man ihn erneut angeben. Die Namensproblematik ist wirklich vorhanden, denn wenn man es nicht so kompliziert haben möchte, wird einem statt des Namens die ID-Nummer angezeigt. Das ist ein großer Nachteil der GUI. Was soll das heißen, dass ich die Maschine, die ich vor 10 Minuten erstellt habe, in einer Liste mit mehr als 100 Maschinen suchen muss? Nein, ich möchte meine Zeit nicht damit verschwenden, Filter einzustellen. 4/10

## 🟨 GCP

**Meine Erfahrung:**

> Die Benutzeroberfläche erinnert an ein Einstellungsmenü eines Google Pixel mit Android 11. Völlig langweilig und unerwartet von Google. 6/10

### Direkter Vergleich

> Wenn man sich nicht mit vielen Command Lines beschäftigen möchte, kann man weiterhin alle Arbeiten über die GUI erledigen. Allerdings ist nicht jedes Design so gut, wie man es erwarten würde. Deshalb: Azure → GCP → AWS.

---

# 🧭 Navigation

## 🟦 Azure

**Meine Erfahrung:**

> Nicht viel zu sagen. Einfach. Ich finde es gut, dass Microsoft seine Traditionen und eigenen Produkte berücksichtigt, zum Beispiel mit der PowerShell Console zusammen mit Bash. Man muss Bash nicht vollständig lernen. 10/10

## 🟧 AWS

**Meine Erfahrung:**

> Einfach wie Azure. 10/10

## 🟨 GCP

**Meine Erfahrung:**

> Was soll das heißen, dass ich eine API installieren muss, um auf eine VM zuzugreifen, die ich installiert habe? 5/10

### Direkter Vergleich

> Keine Erklärung erforderlich. Azure = AWS > GCP.

---

# 💻 CLI-Erfahrung

## 🟦 Azure

**Meine Erfahrung:**

> Wenn ich ein kostenloses Subscription habe, warum gehöre ich dann nicht zu „az“? Warum muss ich meine Tenant ID und Subscription ID abrufen? 9/10

## 🟧 AWS

**Meine Erfahrung:**

> Nichts Besonderes. Alles gut. 10/10

## 🟨 GCP

**Meine Erfahrung:**

> Dasselbe wie bei AWS. 10/10

### Direkter Vergleich

> Alle CLIs und Consoles sind gut, aber es wäre etwas besser, wenn Microsoft das Problem beheben würde, dass die az Command Line das kostenlose Subscription nicht erkennt. AWS=GCP>Azure

---

# 🛠️ Troubleshooting

## 🟦 Azure

**Meine Erfahrung:**

> Ich konnte die Arbeit nicht durchführen, weil ich etwas falsch gemacht hatte. Aber was soll ich mit der Error ID anfangen? 0/10

## 🟧 AWS

**Meine Erfahrung:**

> Gut. Wenn etwas kaputtgeht, werden die Fehler angezeigt, und selbst wenn man sie nicht kennt, kann man sie bei Google finden. Es wäre jedoch besser, wenn sie direkt recherchiert und benutzerfreundlich erklärt würden. 8/10

## 🟨 GCP

**Meine Erfahrung:**

> Dasselbe wie bei AWS. Wenigstens erhält man Informationen über den Fehler. 8/10

### Direkter Vergleich

> Grundsätzlich ist es bei Azure einfacher, mit einem Fehler umzugehen, den man bereits kennt, wenn man weiß, was man 10 Stunden zuvor gemacht hat. Andernfalls ist eine Error ID, mit der man nichts anfangen kann, nichts weiter als leere Information. AWS=GCP>Azure

---

# 📈 Learning Curve

## 🟦 Azure

**Meine Erfahrung:**

> Meiner Meinung nach hat Azure die beste Lernplattform. Microsoft Learn erklärt alles so, als würde man mit einer Person sprechen, die keinerlei Vorkenntnisse besitzt, verwendet dabei aber zu viele Wörter. Microsoft bietet außerdem Videos für jeden Inhalt in Microsoft Learn an, die sehenswert sind; ich lerne jedoch nicht durch Videos oder Lesen. Außerdem bietet Azure detailliertere IAM-, VM- und Security-Einstellungen. 8/10

## 🟧 AWS

**Meine Erfahrung:**

> Kurze Erklärungen. Brilliant. Die Sprachunterstützung ist schlecht. Indonesisch ist vorhanden, aber kein Russisch, Arabisch oder Schwedisch? 6/10

## 🟨 GCP

**Meine Erfahrung:**

> Wir sprechen über Google. Natürlich sieht alles extrem schön aus. Wenn man verwirrt ist, gibt es sogar Roadmaps. Auch Home-Labs sind vorhanden. Das Problem ist, dass es kein Textdokument gibt. Wir sind nicht in der Schule. 9/10

### Direkter Vergleich

> GCP ist hauptsächlich auf sprachliche Erklärungen ausgerichtet (falls es eine Textversion gibt, werde ich diesen Abschnitt entsprechend ändern), aber es erklärt, was man tun sollte. Azure erklärt gerne zu viel, wodurch der Kopf überlastet werden kann. AWS hält die Dinge einfach. Man lernt schnell, aber manchmal kann etwas fehlen. GCP>Azure>AWS

---

# 🤖 AI-Assisted Experience

Diese Kategorie konzentriert sich auf meine praktischen Erfahrungen mit KI-gestützten Tools beim Lernen und Arbeiten mit Cloud-Plattformen.

Ich habe KI-Systeme mit verschiedenen Anfragen getestet, darunter:

* Troubleshooting-Anfragen
* Antwortgeschwindigkeit
* Wissen über meine verwendeten Entities

## 🟦 Azure

**Meine Erfahrung:**

> Ich möchte meine „TENANT ID und NICHT meine SUBSCRIPTION ID“ wissen. Was soll das heißen, dass es 50 Sekunden dauert, mir zu sagen, dass ich klicken muss, um meine IDs zu erfahren? 1/10

## 🟧 AWS

**Meine Erfahrung:**

> Die GUI unterstützt keine mehreren Sprachen, aber Amazon Q schon. Gute Erklärung in kurzer Zeit, aber keine Unterstützung für die Erstellung von Bildern (auch wenn das eigentlich unnötig ist). 9/10

## 🟨 GCP

**Meine Erfahrung:**

> Die Cloud-Version von Gemini macht alles, was ich möchte, auch wenn sie erklärt, dass es nicht das normale Gemini ist und warum. Wenn ich Probleme habe, hilft Gemini und erklärt, was falsch ist. Es macht alles, was ich möchte. 10/10

### Direkter Vergleich

> Microsoft liegt beim KI-Wettbewerb weit zurück. Ich dachte, dass sie Azure stärker verbessern würden. Die anderen KI-Systeme sind ziemlich nützlich. GCP>AWS>Azure

---

# 👤 Gesamte Benutzererfahrung

## 🟦 Azure

**Meine Erfahrung:**

> Die Arbeit mit Azure war ziemlich angenehm, und ich kann klar sagen, dass es gut war, mit Azure angefangen zu haben. Der Grund dafür ist, dass ich seit meiner Kindheit Windows verwende und Active Directory bereits kenne, wodurch mir die Begriffe und deren Verwendung vertraut waren. Azure war die detaillierteste Cloud-Plattform. Ein kleiner Nachteil für Praktiker ist jedoch, dass viele Dinge kostenpflichtig und nicht im kostenlosen Subscription enthalten sind (z. B. NAT Gateway). Unter Berücksichtigung aller positiven und negativen Aspekte gebe ich hier solide 6 Punkte. Die -4 Punkte entstehen durch die Schwierigkeit, Probleme bereits während der Entity-Erstellung zu erkennen, die geringere Zonenverfügbarkeit, teilweise fehlende Maschinenverfügbarkeit in einer Zone und Copilot.

## 🟧 AWS

**Meine Erfahrung:**

> AWS war für mich sehr schwer zu lernen, weil ich hauptsächlich Azure verwendet hatte. Als ich mich an AWS gewöhnt hatte, erkannte ich die Unterschiede. Die UI von AWS war beispielsweise moderner, aber komplizierter als die von Azure. Ein großer Unterschied zwischen diesen Clouds ist die Zonenverfügbarkeit und die Verfügbarkeit von Maschinen in den jeweiligen Zonen. Unter Berücksichtigung aller positiven und negativen Aspekte gebe ich AWS eine 8, weil die Komplexität der Entities dazu führt, dass GUI-Benutzer deutlich mehr Zeit als bei Azure und GCP benötigen.

## 🟨 GCP

**Meine Erfahrung:**

> Bei meiner ersten Interaktion mit GCP wollte ich die Plattform wegen der schrecklichen UI direkt verlassen. Ich benutze kein Android-Telefon. Ein weiterer großer Nachteil ist, dass die Suche nach einem bestimmten Entity-Namen (z. B. app01) nicht funktioniert. Azure und AWS haben hier einen größeren Vorteil. In anderer Hinsicht ist die UI einfacher als bei AWS. Die regionale und zonale Flexibilität ist sogar besser als bei Azure und AWS, wodurch GCP in diesem Bereich gegenüber den Konkurrenten Vorteile hat. Aufgrund der UI gebe ich hier solide 9 Punkte.

---

# 💳💵🤑 Preisvergleich

In diesem Bereich habe ich die Kosten von Virtual Machines an den drei Plattformen verglichen. Denn wenn man ein System lernen möchte, sollte man es mit seinen positiven und negativen Seiten kennenlernen. Dieser Abschnitt behandelt Preisinformationen für Unternehmen und Startups im Hinblick auf ein besseres Kostenmanagement.

Einige Informationen:

Ich habe meinen Standort auf Frankfurt festgelegt, da die Azure-Preise regional unterschiedlich sind.

Ich habe drei Maschinen mit unterschiedlichen Ressourcen festgelegt.

# Maschinentabelle:

|        Level       |   CPU  |  RAM  |     SSD    |  Azure  |     AWS     |      GCP      |
| :----------------: | :----: | :---: | :--------: | :-----: | :---------: | :-----------: |
| **Wirtschaftlich** | 2 vCPU |  8 GB |  64 GB SSD | D2as v5 |  m6i.large  | e2-standard-2 |
|     **Mittel**     | 4 vCPU | 16 GB | 128 GB SSD | D4as v5 |  m6i.xlarge | e2-standard-4 |
|      **Teuer**     | 8 vCPU | 32 GB | 256 GB SSD | D8as v5 | m6i.2xlarge | e2-standard-8 |

Dies sind Maschinen mit vergleichbaren Ressourcen für einen fairen Preisvergleich. Die Quelle kann veraltet sein.

# Stundenpreise:

|        Level       |     Azure     |      AWS     |         GCP         |
| :----------------: | :-----------: | :----------: | :-----------------: |
|  **2 vCPU / 8 GB** | **~$0.096/h** | **$0.115/h** |    **~$0.067/h**    |
| **4 vCPU / 16 GB** | **~$0.208/h** | **$0.230/h** | **~$0.134–0.173/h** |
| **8 vCPU / 32 GB** | **~$0.416/h** | **$0.460/h** | **~$0.268–0.346/h** |

Monatliche Preise (berechnet mit 730 Stunden / 30,41666 Tagen):

|        Level       |      Azure      |       AWS       |         GCP         |
| :----------------: | :-------------: | :-------------: | :-----------------: |
|  **2 vCPU / 8 GB** |  **~$70/Monat** |  **~$84/Monat** |    **~$49/Monat**   |
| **4 vCPU / 16 GB** | **~$152/Monat** | **~$168/Monat** |  **~$98–126/Monat** |
| **8 vCPU / 32 GB** | **~$304/Monat** | **~$336/Monat** | **~$196–253/Monat** |

Aus der Tabelle ist ersichtlich, dass GCP im Vergleich zu den Konkurrenten günstigere Services anbietet.

Beim Vergleich zwischen Azure und AWS liegt Azure in diesem Bereich vorne. Dies könnte auf die Verfügbarkeit zurückzuführen sein, da AWS nicht immer dieselbe Verfügbarkeit bietet.

---

# 💥 Lernen durch Fehler

Fehler waren ein bewusster Bestandteil meines Lernprozesses.

Ich habe nicht versucht, jede Lab-Umgebung in einem perfekten Zustand zu halten.

Stattdessen wollte ich verstehen, was passiert, wenn Infrastruktur falsch konfiguriert wird.

Zum Beispiel:

* Falsche Firewall-Regeln
* Fehlende IAM-Berechtigungen
* Netzwerkprobleme
* DNS-Probleme
* Terraform-State-/Konfigurationsabweichungen
* Falsche Resource-Abhängigkeiten
* Connectivity-Probleme

Mein allgemeiner Ansatz:

```text
Build
  ↓
Understand
  ↓
Change
  ↓
Break
  ↓
Investigate
  ↓
Troubleshoot
  ↓
Fix
  ↓
Destroy
  ↓
Rebuild
```

Dadurch erhielt ich praktische Erfahrung, die nicht allein durch das Auswendiglernen von Definitionen für Cloud-Services erreicht werden kann.

---

# 🧠 Die Philosophie

Das Hauptziel dieser Reise war nicht einfach, mehr Services zu lernen.

Es ging darum, ein **praktisches Infrastructure Mindset** zu entwickeln.

Ich wollte verstehen:

> **Wie funktioniert es?**

Dann:

> **Warum funktioniert es?**

Und schließlich:

> **Was passiert, wenn es kaputtgeht?**

Deshalb folgt mein Lernprozess immer wieder diesem Muster:

```text
Learn
  ↓
Build
  ↓
Break
  ↓
Troubleshoot
  ↓
Fix
  ↓
Destroy
  ↓
Rebuild
```

Für mich entsteht praktische Erfahrung durch **die direkte Arbeit mit Infrastruktur und nicht nur durch das Lesen darüber**.

---

# 📌 Bewertungsumfang

Diese Seite stellt meine persönlichen Erfahrungen bis zum **23. September 2026** dar.

Der Vergleich basiert auf:

* Meinen eigenen Hands-on-Labs
* Den von mir erstellten Cloud-Infrastrukturen
* Networking-Konfigurationen
* IAM- und Authorization-Arbeiten
* CLI-Nutzung
* Terraform-Projekten
* Troubleshooting-Erfahrungen
* Dokumentation
* KI-gestütztem Lernen
* Meinem persönlichen Lernprozess

> **Dies ist kein objektiver Benchmark und keine Branchenrangliste.**

Andere Benutzer können abhängig von folgenden Faktoren völlig andere Erfahrungen machen:

* Hintergrund
* Workload
* Organisation
* Vorhandene technische Kenntnisse
* Bevorzugte Tools
* Lernansatz

Der Zweck dieser Seite besteht lediglich darin, **meine eigenen praktischen Erfahrungen mit Azure, AWS und GCP** zu dokumentieren.

---

# 📚 Quellen

Die folgenden Ressourcen wurden während meiner Lernreise sowie beim Aufbau und Troubleshooting der in diesem Portfolio dokumentierten Cloud-Umgebungen verwendet.

## 📖 Offizielle Dokumentation & Lernplattformen

| Ressource                         | Zweck                                                                                                 |
| --------------------------------- | ----------------------------------------------------------------------------------------------------- |
| **Microsoft Learn**               | Wichtigste Lernressource während der Azure- und AZ-104-basierten Lernphase                            |
| **Microsoft Azure Documentation** | Dokumentation zu Azure-Services, Administration, Networking, Identity, Monitoring und Troubleshooting |
| **AWS Documentation**             | AWS-Services, Architecture, CLI, Networking, IAM und Troubleshooting                                  |
| **Google Cloud Documentation**    | GCP-Services, Networking, IAM, Compute Engine, Monitoring und Troubleshooting                         |
| **Terraform Documentation**       | Infrastructure-as-Code-Konzepte, Terraform-Konfiguration, Provider, Ressourcen, State und Workflows   |

## 🤖 KI-gestütztes Lernen

| Tool                  | Verwendung                                                                                                            |
| --------------------- | --------------------------------------------------------------------------------------------------------------------- |
| **ChatGPT**           | Interaktives Lernen, Troubleshooting, Architekturgespräche, Terraform, CLI-Unterstützung und szenariobasiertes Lernen |
| **Google Gemini**     | Alternative Erklärungen, Troubleshooting-Ansätze und technische Gegenprüfung                                          |
| **Microsoft Copilot** | Unterstützung im Microsoft-Ökosystem und bei Cloud-Themen                                                             |

## 🎥 Videoressourcen

* Microsoft Azure
* AWS
* Google Cloud Tech
* Microsoft Mechanics
* NetworkChuck
* TechWorld with Nana

## 🧪 Persönliche Hands-on-Labs

Der Vergleich basiert außerdem auf meinen eigenen Hands-on-Umgebungen, darunter:

* Azure-Administration und Infrastructure Labs
* Windows Server / Active Directory Labs
* Azure + On-Premises Hybrid Infrastructure
* AWS Infrastructure Lab
* GCP Infrastructure Lab
* Terraform Infrastructure-as-Code-Projekte
* Docker- und Containerization-Übungen

---

## 📝 Schlussbemerkung

Alle Beobachtungen und Vergleiche auf dieser Seite basieren auf meinen **persönlichen praktischen Erfahrungen** mit diesen Ressourcen und Umgebungen.

Diese Seite dokumentiert meine Lernreise, die von mir erstellte Infrastruktur, die aufgetretenen Probleme und meine Erfahrungen mit den einzelnen Cloud-Plattformen.

Die Dokumentation kann zum Lernen und auch in anderen Dokumentationen, Videos oder Blogs verwendet werden. Wenn du eine meiner Seiten oder Quellen verwenden möchtest, kannst du dies gerne tun; eine Quellenangabe würde mich jedoch freuen, da ich dadurch weiß, dass meine Arbeit gesehen und verwendet wird.

Die Dokumentation wird jedes Mal aktualisiert, wenn ich einen Fehler entdecke.

* Vielen Dank für den Besuch meines Portfolios.

---

**Letzte Aktualisierung:** `24. September 2026, 00:57 Uhr GMT +3, Istanbul`
