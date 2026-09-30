# 🔄 CI/CD Pipeline Lab

Ein praxisorientiertes CI/CD-Labor, das entwickelt wurde, um praktische Kenntnisse in Continuous Integration, automatisierten Tests, Workflow-Automatisierung, dem Erstellen von Docker-Images und der Fehleranalyse von Pipelines zu entwickeln.

Das Hauptziel dieses Labors besteht darin, die Softwarevalidierung und den Build-Prozess mithilfe von GitHub Actions zu automatisieren, anstatt diese Aufgaben manuell durchzuführen.

---

## 📌 Projektübersicht

Dieses Labor demonstriert einen auf GitHub Actions basierenden CI/CD-Workflow.

Das Projekt behandelt folgende Bereiche:

* Git und GitHub
* GitHub Actions
* Workflow-Konfiguration
* Automatisierte Tests
* Continuous Integration
* Erstellung von Docker-Images
* Pipeline-Ausführung
* Workflow-Logs
* Fehlerbehandlung
* Build-Verifizierung

---

## 1. 📦 Repository & Projektstruktur

Der Quellcode des Projekts wird in einem GitHub-Repository verwaltet.

Git wird zur Versionsverwaltung des Quellcodes verwendet, während GitHub das Repository und die Ausführungsumgebung für GitHub Actions bereitstellt.

### Projektstruktur

| **Komponente**       | **Zweck**                             |
| -------------------- | ------------------------------------- |
| Quellcode            | Quelldateien der Anwendung            |
| `Dockerfile`         | Definiert den Build des Docker-Images |
| `.github/workflows/` | Enthält GitHub Actions Workflows      |
| Workflow YAML        | Definiert die CI/CD-Pipeline          |
| Git-Repository       | Verfolgt Änderungen am Projekt        |

### 📸 Screenshot 01 — Projektstruktur

[Projektstruktur](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/blob/main/cicd/01-project-structure.png) ([Bild](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/raw/main/cicd/01-project-structure.png))

---

## 2. ⚙️ GitHub Actions Workflow

GitHub Actions wird verwendet, um die CI/CD-Pipeline zu automatisieren.

Der Workflow wird mithilfe einer YAML-Konfigurationsdatei im Verzeichnis `.github/workflows/` definiert.

### Workflow-Konfiguration

| **Komponente** | **Konfiguration**    |
| -------------- | -------------------- |
| CI-Plattform   | GitHub Actions       |
| Konfiguration  | YAML                 |
| Trigger        | Git-Repository-Event |
| Tests          | Automatisiert        |
| Docker Build   | Automatisiert        |
| Logs           | GitHub Actions       |

### Workflow-Struktur

```text
.github/
└── workflows/
    └── ci.yml
```

Der Workflow definiert die Reihenfolge der automatisierten Aufgaben, die ausgeführt werden, wenn das konfigurierte Repository-Event ausgelöst wird.

### 📸 Screenshot 02 — GitHub Actions Workflow

[GitHub Actions Workflow](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/blob/main/cicd/02-workflow.png) ([Bild](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/raw/main/cicd/02-workflow.png))

---

## 3. 🧪 Automatisierte Tests

Die CI-Pipeline führt nach dem Auslösen des Workflows automatisch die konfigurierten Tests aus.

Dadurch können Codeänderungen automatisch validiert werden, bevor die Pipeline fortgesetzt wird.

### Testprozess

```text
Codeänderung
     │
     ▼
GitHub Actions
     │
     ▼
Automatisierte Tests
     │
 ┌───┴────┐
 ▼        ▼
BESTANDEN FEHLER
 │        │
 ▼        ▼
Weiter    Stop
```

### Testergebnisse

| **Ergebnis**         | **Verhalten der Pipeline**     |
| -------------------- | ------------------------------ |
| Tests bestanden      | Workflow wird fortgesetzt      |
| Tests fehlgeschlagen | Workflow meldet einen Fehler   |
| Testausgabe          | In den Workflow-Logs verfügbar |

### 📸 Screenshot 03 — Automatisierte Tests

[Automatisierte Tests](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/blob/main/cicd/03-tests.png) ([Bild](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/raw/main/cicd/03-tests.png))

---

## 4. 🐳 Docker-Image erstellen

Docker ist in den CI/CD-Workflow integriert, um automatisch ein Container-Image zu erstellen.

Das Docker-Image wird mithilfe der `Dockerfile` des Projekts erstellt.

### Docker-Konfiguration

| **Komponente** | **Zweck**                                     |
| -------------- | --------------------------------------------- |
| Dockerfile     | Definiert die Anweisungen für den Image-Build |
| Docker Build   | Erstellt das Container-Image                  |
| GitHub Actions | Automatisiert den Build                       |
| Build-Logs     | Stellen Build-Ausgabe und Fehler bereit       |

### Build-Prozess

```text
Quellcode
     │
     ▼
Dockerfile
     │
     ▼
Docker Build
     │
     ▼
Docker-Image
```

Der Docker-Build-Schritt zeigt, wie die Erstellung von Container-Images in einen automatisierten CI-Workflow integriert werden kann.

### 📸 Screenshot 04 — Docker Build

[Docker Build](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/blob/main/cicd/04-docker-build.png) ([Bild](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/raw/main/cicd/04-docker-build.png))

---

## 5. 🚀 Pipeline-Ausführung

Nachdem ein Repository-Event den Workflow auslöst, führt GitHub Actions die konfigurierten Pipeline-Schritte aus.

Jeder Schritt meldet seinen Ausführungsstatus und stellt Logs zur Fehleranalyse bereit.

### Pipeline-Schritte

| **Schritt**  | **Zweck**                             | **Ergebnis**                 |
| ------------ | ------------------------------------- | ---------------------------- |
| Checkout     | Ruft den Quellcode des Repositorys ab | Quellcode verfügbar          |
| Test         | Validiert das Projekt                 | Bestanden / Fehlgeschlagen   |
| Docker Build | Erstellt das Container-Image          | Erfolgreich / Fehlgeschlagen |
| Workflow     | Meldet den finalen Pipeline-Status    | Erfolgreich / Fehlgeschlagen |

Eine erfolgreiche Pipeline bedeutet, dass alle erforderlichen Schritte ohne Fehler abgeschlossen wurden.

### 📸 Screenshot 05 — Erfolgreiche Pipeline

[Erfolgreiche Pipeline](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/blob/main/cicd/05-pipeline-success.png) ([Bild](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/raw/main/cicd/05-pipeline-success.png))

---

## 6. ❌ Fehlerbehandlung

CI/CD-Pipelines müssen Fehler erkennen und aussagekräftiges Feedback liefern.

Wenn ein Test oder ein Docker-Build fehlschlägt, meldet GitHub Actions den Workflow als fehlgeschlagen.

Die Workflow-Logs können anschließend verwendet werden, um den fehlgeschlagenen Schritt zu identifizieren und die Ursache zu untersuchen.

### Fehlerbehandlung

| **Situation**            | **Ergebnis**                     |
| ------------------------ | -------------------------------- |
| Testfehler               | Pipeline meldet einen Fehler     |
| Docker-Build-Fehler      | Pipeline meldet einen Fehler     |
| Erfolgreicher Schritt    | Pipeline wird fortgesetzt        |
| Fehlgeschlagener Schritt | Fehler ist in den Logs verfügbar |

### Fehler-Workflow

```text
Codeänderung
     │
     ▼
GitHub Actions
     │
     ▼
Test / Docker Build
     │
     ▼
   Fehler
     │
     ▼
Workflow-Logs überprüfen
     │
     ▼
Fehler beheben
     │
     ▼
Änderungen pushen
```

### 📸 Screenshot 06 — Fehlgeschlagene Pipeline

[Fehlgeschlagene Pipeline](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/blob/main/cicd/06-pipeline-failure.png) ([Bild](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/raw/main/cicd/06-pipeline-failure.png))

---

## 7. 🔁 Pipeline-Verifizierung

Nach der Behebung des Problems kann der Workflow erneut ausgeführt werden.

Eine erfolgreiche Ausführung bestätigt, dass das Problem behoben wurde und die vollständige Pipeline erfolgreich abgeschlossen werden kann.

### Verifizierung

| **Prüfung**      | **Erwartetes Ergebnis** |
| ---------------- | ----------------------- |
| Workflow startet | Erfolgreich             |
| Tests            | Bestanden               |
| Docker Build     | Erfolgreich             |
| Workflow-Status  | Erfolgreich             |
| Logs             | Keine ungelösten Fehler |

### 📸 Screenshot 07 — Erfolgreiche Pipeline-Verifizierung

[Pipeline-Verifizierung](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/blob/main/cicd/07-pipeline-verification.png) ([Bild](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/raw/main/cicd/07-pipeline-verification.png))

---

## 8. 📋 Workflow-Logs

GitHub Actions stellt detaillierte Logs für jeden Workflow-Schritt bereit.

Diese Logs wurden verwendet, um die Ausführung zu überprüfen und Fehler innerhalb der Pipeline zu analysieren.

### Log-Verifizierung

| **Log-Information** | **Zweck**                             |
| ------------------- | ------------------------------------- |
| Schrittstatus       | Zeigt, ob ein Schritt erfolgreich war |
| Testausgabe         | Überprüft die automatisierten Tests   |
| Docker-Ausgabe      | Überprüft den Image-Build             |
| Fehlermeldungen     | Unterstützen bei der Fehleranalyse    |
| Finaler Status      | Bestätigt das Pipeline-Ergebnis       |

### 📸 Screenshot 08 — Workflow-Logs

[Workflow-Logs](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/blob/main/cicd/08-workflow-logs.png) ([Bild](https://github.com/darwin642/CLOUD-DEVOPS-HOMELAB/raw/main/cicd/08-workflow-logs.png))

---

## 🛠️ Technologien

**CI/CD**

GitHub Actions

**Versionskontrolle**

Git · GitHub

**Container**

Docker

**Konfiguration**

YAML

**Automatisierung**

GitHub Actions Workflows

---

## 📚 Nachgewiesene Kenntnisse

* Git-Versionskontrolle
* Verwaltung von GitHub-Repositories
* GitHub Actions
* Entwicklung von CI/CD-Workflows
* YAML-Konfiguration
* Automatisierte Tests
* Erstellung von Docker-Images
* Fehleranalyse und Troubleshooting von Pipelines
* Analyse von Workflow-Logs
* Fehlerbehandlung
* Continuous Integration
* Automatisierte Build-Verifizierung

---

## 🚀 Nächste Schritte

Geplante Erweiterungen für das CI/CD-Labor:

* Veröffentlichung von Docker-Images
* Integration einer Container Registry
* Validierung von Pull Requests
* Verwaltung von Secrets
* Automatisierung von Deployments
* Umgebungsabhängige Workflows
* Integration mit Terraform
* Kubernetes-Deployment
* Cloud-basierte Deployment-Pipelines

---

## 📌 Projektstatus

Dieses Labor demonstriert einen praxisorientierten GitHub Actions CI/CD-Workflow mit automatisierten Tests, Docker-Image-Erstellung, Pipeline-Verifizierung und Fehleranalyse.

Das Projekt bietet praktische Erfahrung mit automatisierter Softwarevalidierung, Workflow-Automatisierung und containerbasierten Build-Prozessen.

Das Labor kann zukünftig um zusätzliche Deployment- und Cloud-Automatisierungsszenarien erweitert werden.
