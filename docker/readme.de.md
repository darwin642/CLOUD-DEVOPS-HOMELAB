# 🐳 Docker Anwendungs- & Containerization-Labor

Praktisches Docker-Labor zur Entwicklung von praxisnahen Kenntnissen in den Bereichen Containerisierung, Anwendungsbereitstellung, Netzwerk, Storage, Docker Compose, CI/CD und Container-Sicherheit.

Das Labor konzentriert sich auf das Erstellen, Konfigurieren, Testen, Troubleshooting, Automatisieren und Absichern containerisierter Anwendungen in einer realistischen DevOps-Umgebung.

---

## 📌 Projektübersicht

Dieses Labor umfasst die Bereitstellung und Verwaltung containerisierter Anwendungen mit Docker.

Das Projekt beinhaltet:

* Docker Images
* Docker Container
* Dockerfiles
* Verwaltung des Container-Lebenszyklus
* Port-Mapping
* Bind Mounts
* Named Volumes
* Docker Netzwerke
* Kommunikation zwischen Containern
* Docker Compose
* Multi-Container-Anwendungen
* PostgreSQL-Persistenz
* Healthchecks
* Multi-Stage Builds
* Nginx Reverse Proxy
* Ressourcenlimits
* Logging
* Restart Policies
* Docker Hub
* Manuelle CI/CD-Pipeline
* Semantic Versioning
* Container-Sicherheit
* Vulnerability Scanning

---

## 🏗️ Architektur

### Architekturdiagramm

Die Hauptanwendungsumgebung besteht aus einem Nginx Reverse Proxy, einer Backend-Anwendung und einer PostgreSQL-Datenbank, die als separate Container ausgeführt werden.

Die Anwendung verwendet Docker-Netzwerke für die Kommunikation zwischen den Services und ein persistentes Volume für die Datenbankspeicherung.

Hier ist das Diagramm;

![Docker Architecture](docker_diagram.jpg)

```text id="katled"
                         CLIENT
                            │
                            ▼
                    ┌──────────────┐
                    │    Nginx     │
                    │ Reverse Proxy│
                    │    :8080     │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │   Backend    │
                    │    :5000     │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │  PostgreSQL  │
                    │    :5432     │
                    └──────┬───────┘
                           │
                           ▼
                    postgres-data
                       Volume
```

---

## 1. 🖼️ Docker Images

Docker Images wurden als Grundlage für die Bereitstellung von Containern erstellt und verwaltet.

Im Labor wurden sowohl offizielle Images als auch eigene Images mithilfe von Dockerfiles verwendet.

### Konfiguration

| Ressource             | Konfiguration             |
| --------------------- | ------------------------- |
| Basis-Image           | `nginx:alpine`            |
| Anwendungs-Image      | `my-web:v1` / `my-web:v2` |
| Backend-Image         | `my-backend:v1`           |
| Registry              | Docker Hub                |
| Docker-Hub-Repository | `darwin642/my-web`        |

### 📸 Screenshot 01 — Docker Images

![Docker Images](01-docker-images.png)

### 📸 Screenshot 02 — Eigenes Docker Image

![Custom Docker Image](02-custom-image.png)

### 📸 Screenshot 03 — Docker Image History

![Docker Image History](03-image-history.png)

---

## 2. 📦 Docker Container

Docker Container wurden erstellt, gestartet, gestoppt, untersucht und entfernt, um den Lebenszyklus eines Containers zu demonstrieren.

Während des Labors wurden mehrere Nginx-Container bereitgestellt.

### Konfiguration

| Container | Image          | Port   |
| --------- | -------------- | ------ |
| `web01`   | `nginx:alpine` | `8080` |
| `web02`   | `my-web:v1`    | `8081` |
| `web03`   | `my-web:v2`    | `8082` |

### 📸 Screenshot 04 — Laufende Container

![Running Containers](04-running-containers.png)

### 📸 Screenshot 05 — Containerdetails

![Container Details](05-container-details.png)

### 📸 Screenshot 06 — Container-Lebenszyklus

![Container Lifecycle](06-container-lifecycle.png)

---

## 3. 🐳 Dockerfile & Anwendungs-Containerisierung

Ein eigenes Anwendungs-Image wurde mithilfe eines Dockerfiles erstellt.

Das Dockerfile definiert die Anwendungsumgebung, das Arbeitsverzeichnis, Abhängigkeiten, Dateien und den Startbefehl.

Die Anwendung wurde anschließend in ein Docker Image verpackt und als Container bereitgestellt.

### 📸 Screenshot 07 — Dockerfile

![Dockerfile](07-dockerfile.png)

### 📸 Screenshot 08 — Docker Build

![Docker Build](08-docker-build.png)

### 📸 Screenshot 09 — Containerisierte Anwendung

![Containerized Application](09-containerized-application.png)

---

## 4. 🔌 Port-Mapping

Docker Port-Mapping wurde konfiguriert, um containerisierte Anwendungen für das Host-System bereitzustellen.

Im Labor wurden unterschiedliche Host-Ports verwendet, damit mehrere Anwendungscontainer gleichzeitig ausgeführt werden konnten.

### Konfiguration

| Container | Container-Port | Host-Port |
| --------- | -------------- | --------- |
| `web01`   | `80`           | `8080`    |
| `web02`   | `80`           | `8081`    |
| `web03`   | `80`           | `8082`    |

### 📸 Screenshot 10 — Port-Mapping

![Port Mapping](10-port-mapping.png)

### 📸 Screenshot 11 — Anwendungszugriff

![Application Access](11-application-access.png)

---

## 5. 💾 Volumes & Bind Mounts

Docker Storage wurde sowohl mit Named Volumes als auch mit Bind Mounts getestet.

Ein Named Volume wurde für persistenten Container-Speicher verwendet, während ein Bind Mount ein Host-Verzeichnis in einen Container eingebunden hat.

### Konfiguration

| Storage-Typ    | Beispiel                 |
| -------------- | ------------------------ |
| Named Volume   | `nginx-data`             |
| Bind Mount     | `E:\docker\compose-demo` |
| Container-Pfad | `/usr/share/nginx/html`  |

### 📸 Screenshot 12 — Docker Volume

![Docker Volume](12-docker-volume.png)

### 📸 Screenshot 13 — Volume Mount

![Volume Mount](13-volume-mount.png)

### 📸 Screenshot 14 — Bind Mount

![Bind Mount](14-bind-mount.png)

---

## 6. 🌐 Docker Netzwerke

Ein eigenes Docker-Bridge-Netzwerk wurde erstellt, damit Container über Docker-internes Networking und Servicenamen miteinander kommunizieren können.

Die Kommunikation zwischen Containern wurde erfolgreich getestet.

### Konfiguration

| Ressource         | Konfiguration          |
| ----------------- | ---------------------- |
| Netzwerk          | `app-network`          |
| Netzwerktyp       | Bridge                 |
| Kommunikation     | Container-zu-Container |
| Service-Auflösung | Docker DNS             |

Die Backend-Container konnten über Container- bzw. Servicenamen kommunizieren, ohne Host-IP-Adressen verwenden zu müssen.

### 📸 Screenshot 15 — Docker Netzwerk

![Docker Network](15-docker-network.png)

### 📸 Screenshot 16 — Netzwerk-Container

![Network Containers](16-network-containers.png)

### 📸 Screenshot 17 — Container-zu-Container-Kommunikation

![Container-to-Container Communication](17-container-communication.png)

---

## 7. 🧩 Docker Compose

Docker Compose wurde verwendet, um eine Multi-Container-Anwendungsumgebung zu definieren und zu verwalten.

Die Compose-Umgebung umfasst eine Backend-Anwendung und eine PostgreSQL-Datenbank mit persistentem Storage und Healthchecks.

### Konfiguration

| Service    | Zweck                          |
| ---------- | ------------------------------ |
| Backend    | Anwendungsservice              |
| PostgreSQL | Datenbank                      |
| Nginx      | Reverse Proxy                  |
| Volume     | Persistenter Datenbank-Storage |
| Netzwerk   | Service-Kommunikation          |

Zusätzlich wurden Umgebungsvariablen zur Konfiguration der Anwendung und Datenbank verwendet.

### 📸 Screenshot 18 — Docker Compose Datei

![Docker Compose](18-compose-file.png)

### 📸 Screenshot 19 — Compose Services

![Compose Services](19-compose-services.png)

### 📸 Screenshot 20 — Compose Anwendung

![Compose Application](20-compose-application.png)

---

## 8. 🗄️ PostgreSQL & Persistente Anwendungsdaten

Ein PostgreSQL-Container wurde in die Multi-Container-Anwendungsumgebung integriert.

Die Datenbank verwendet ein Named Volume, um Daten unabhängig vom Lebenszyklus des Containers persistent zu speichern.

Die Anwendung wurde getestet, indem Container neu erstellt wurden, während das Datenbank-Volume erhalten blieb.

### Konfiguration

| Ressource          | Konfiguration        |
| ------------------ | -------------------- |
| Datenbank          | PostgreSQL           |
| Image              | `postgres:16-alpine` |
| Datenbank-Volume   | `postgres-data`      |
| Datenbank-Port     | `5432`               |
| Datenbank-Netzwerk | `production-network` |

### 📸 Screenshot 21 — PostgreSQL Container

![PostgreSQL Container](21-postgresql-container.png)

### 📸 Screenshot 22 — PostgreSQL Volume

![PostgreSQL Volume](22-postgresql-volume.png)

### 📸 Screenshot 23 — Persistente Daten

![Persistent Data](23-persistent-data.png)

---

## 9. 🩺 Healthchecks & Service-Abhängigkeiten

Docker Healthchecks wurden konfiguriert, um die Verfügbarkeit der PostgreSQL-Datenbank zu überprüfen.

Der Backend-Service wurde so konfiguriert, dass er auf einen erfolgreichen Datenbank-Healthcheck wartet, bevor er gestartet wird.

### Konfiguration

```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U appuser -d appdb"]
  interval: 5s
  timeout: 2s
  retries: 5
```

Der Application Stack wurde gestartet und anschließend überprüft, um sicherzustellen, dass das Backend nach erfolgreichem Datenbank-Healthcheck verfügbar wurde.

### 📸 Screenshot 24 — PostgreSQL Healthcheck

![Healthcheck](24-healthcheck.png)

### 📸 Screenshot 25 — Service Health

![Service Health](25-service-health.png)

---

## 10. 🔀 Nginx Reverse Proxy

Nginx wurde als Reverse Proxy vor der Backend-Anwendung konfiguriert.

Der Reverse Proxy leitet eingehende HTTP-Anfragen über das Docker-Netzwerk an den Backend-Container weiter.

### Konfiguration

| Einstellung     | Wert      |
| --------------- | --------- |
| Proxy           | Nginx     |
| Externer Port   | `8080`    |
| Backend-Port    | `5000`    |
| Backend-Service | `backend` |

Der Backend-Service wurde nicht direkt für das Host-System veröffentlicht. Nginx dient als externer Einstiegspunkt.

### 📸 Screenshot 26 — Nginx Konfiguration

![Nginx Configuration](26-nginx-config.png)

### 📸 Screenshot 27 — Reverse-Proxy-Stack

![Reverse Proxy](27-reverse-proxy.png)

### 📸 Screenshot 28 — HTTP 200 Antwort

![HTTP Response](28-http-response.png)

---

## 11. 🏗️ Multi-Stage Docker Build

Ein Multi-Stage Dockerfile wurde erstellt, um Build-Umgebung und finale Runtime-Umgebung voneinander zu trennen.

Das finale Image enthält nur die benötigten Runtime-Komponenten und reduziert dadurch unnötige Inhalte im Image.

### 📸 Screenshot 29 — Multi-Stage Dockerfile

![Multi-Stage Dockerfile](29-multistage-dockerfile.png)

### 📸 Screenshot 30 — Multi-Stage Build

![Multi-Stage Build](30-multistage-build.png)

---

## 12. ⚡ Docker Build Optimierung

Docker Build-Optimierungstechniken wurden eingesetzt, um den Image-Build effizienter zu gestalten und unnötige Build-Daten zu reduzieren.

Das Projekt verwendet:

* `.dockerignore`
* Layer-bewusste Dockerfile-Struktur
* `pip --no-cache-dir`
* Alpine-basierte Images
* Multi-Stage Builds
* Docker Build Cache

### 📸 Screen
