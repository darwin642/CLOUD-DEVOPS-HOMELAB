# 📊 Prometheus & Grafana Monitoring Lab

Ein praxisorientiertes Monitoring- und Observability-Labor, das mit Prometheus, Grafana, cAdvisor und Docker aufgebaut wurde.

Das Hauptziel dieses Labors ist die Überwachung containerisierter Workloads, die Erfassung von Infrastrukturmetriken und die Visualisierung von System- und Container-Performance mit Grafana-Dashboards.

> [!NOTE]
> Da ich noch Deutsch lerne und meine Deutschkenntnisse derzeit noch nicht auf einem fortgeschrittenen Niveau sind, wurde diese deutsche Version mit Unterstützung von KI erstellt. Dadurch möchte ich sicherstellen, dass die Inhalte möglichst klar und verständlich formuliert sind. Vielen Dank für Ihr Verständnis!

---

## 📌 Projektübersicht

Dieses Labor demonstriert einen containerbasierten Monitoring-Stack mit:

* Prometheus
* Grafana
* cAdvisor
* Docker
* Prometheus Exporter und Metrics
* Monitoring-Dashboards
* Container Resource Monitoring

Die Umgebung wurde aufgebaut, um praktische Erfahrungen mit Monitoring-Konzepten zu sammeln, die häufig in Cloud- und DevOps-Umgebungen eingesetzt werden.

---

## 🏗️ Architektur

Der Monitoring-Stack besteht aus folgenden Komponenten:

```text
                    ┌─────────────────────┐
                    │       Grafana       │
                    │   Visualisierung    │
                    │      Port 3000      │
                    └──────────┬──────────┘
                               │
                               │ Prometheus Data Source
                               ▼
                    ┌─────────────────────┐
                    │     Prometheus      │
                    │   Metrics Storage   │
                    │      Port 9090      │
                    └──────────┬──────────┘
                               │
                    Sammelt Metrics
                               │
              ┌────────────────┴────────────────┐
              │                                 │
              ▼                                 ▼
     ┌─────────────────┐              ┌─────────────────┐
     │     cAdvisor    │              │     Docker      │
     │ Container Metrics│             │   Container     │
     │     Port 8080   │              │                 │
     └─────────────────┘              └─────────────────┘
```

### 📸 Screenshot 01 — Monitoring-Architektur

![Monitoring Architecture](01-monitoring-architecture.png)

---

## 1. 🐳 Docker Monitoring-Umgebung

Der Monitoring-Stack läuft in Docker-Containern.

Die Umgebung enthält:

| Komponente | Zweck                            | Port   |
| ---------- | -------------------------------- | ------ |
| Prometheus | Metrics-Sammlung und Speicherung | `9090` |
| Grafana    | Metrics-Visualisierung           | `3000` |
| cAdvisor   | Container Resource Metrics       | `8080` |

Docker Compose wird verwendet, um die Monitoring-Services zu verwalten.

### 📸 Screenshot 02 — Docker Container

![Docker Containers](02-docker-containers.png)

---

## 2. 📈 Prometheus

Prometheus ist für die Sammlung und Speicherung von Time-Series-Metrics verantwortlich.

Prometheus fragt die konfigurierten Targets regelmäßig ab und stellt die gesammelten Metrics über seine Query-Schnittstelle zur Verfügung.

### Prometheus-Konfiguration

Die Prometheus-Konfiguration definiert die Monitoring-Targets und das Scrape-Intervall.

Beispiel:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090

  - job_name: cadvisor
    static_configs:
      - targets:
          - cadvisor:8080
```

### 📸 Screenshot 03 — Prometheus Targets

![Prometheus Targets](03-prometheus-targets.png)

---

## 3. 🔍 cAdvisor

cAdvisor liefert Container-Level Resource- und Performance-Metrics.

In diesem Labor wird cAdvisor verwendet, um Docker-Container zu überwachen und Metrics bereitzustellen, die von Prometheus gesammelt werden.

Überwachte Informationen umfassen:

* CPU-Auslastung
* Memory-Auslastung
* Netzwerkverkehr
* Container-Aktivität
* Filesystem-Auslastung

### 📸 Screenshot 04 — cAdvisor

![cAdvisor](04-cadvisor.png)

---

## 4. 📊 Grafana

Grafana wird verwendet, um die von Prometheus gesammelten Metrics zu visualisieren.

Prometheus wurde als Data Source in Grafana konfiguriert.

Die Grafana-Umgebung ermöglicht die Analyse von Metrics über Dashboards und Panels.

### 📸 Screenshot 05 — Grafana Dashboard

![Grafana Dashboard](05-grafana-dashboard.png)

---

## 5. 🔗 Prometheus & Grafana Integration

Prometheus wurde als primäre Data Source für Grafana konfiguriert.

Der Integrationsablauf:

```text
Docker Container
       │
       ▼
    cAdvisor
       │
       │ Metrics
       ▼
   Prometheus
       │
       │ Queries
       ▼
     Grafana
       │
       ▼
    Dashboard
```

Damit wird eine grundlegende Monitoring-Pipeline von der Sammlung der Container-Metrics bis zur Visualisierung demonstriert.

### 📸 Screenshot 06 — Grafana Prometheus Data Source

![Grafana Prometheus Data Source](06-grafana-prometheus-datasource.png)

---

## 6. 📉 Metrics & Visualisierung

Das Grafana-Dashboard wurde verwendet, um Container-Performance-Metrics zu visualisieren.

Beispiele:

* CPU-Auslastung
* Memory-Auslastung
* Netzwerkaktivität
* Container Resource Consumption

Das Dashboard bietet eine zentrale Übersicht über die überwachte Umgebung.

### 📸 Screenshot 07 — Container Metrics

![Container Metrics](07-container-metrics.png)

---

## 7. 🧪 Monitoring-Verifizierung

Der Monitoring-Stack wurde überprüft durch:

* Überprüfung der laufenden Docker-Container
* Zugriff auf Prometheus
* Überprüfung der Prometheus Targets
* Überprüfung der von cAdvisor bereitgestellten Metrics
* Zugriff auf Grafana
* Überprüfung der Prometheus-Verbindung in Grafana
* Anzeige der Container-Metrics in Grafana

### Verifizierung

Prometheus:

```text
http://localhost:9090
```

Grafana:

```text
http://localhost:3000
```

cAdvisor:

```text
http://localhost:8080
```

### 📸 Screenshot 08 — Monitoring-Verifizierung

![Monitoring Verification](08-monitoring-verification.png)

---

## 🛠️ Technologien

**Monitoring**

Prometheus · Grafana · cAdvisor

**Container**

Docker · Docker Compose

**Metrics**

CPU · Memory · Network · Container Metrics

**Visualisierung**

Grafana Dashboards

---

## 📚 Demonstrierte Skills

* Prometheus-Konfiguration
* Metrics Collection
* Time-Series Monitoring
* Grafana Dashboard-Konfiguration
* Grafana Data Sources
* Container Monitoring
* cAdvisor
* Docker Compose
* Infrastructure Observability
* Monitoring Troubleshooting
* Grundlegende Cloud/DevOps Observability-Praktiken

---

## 🚀 Nächste Schritte

Geplante Erweiterungen:

* Node Exporter
* Linux Host Monitoring
* Alertmanager
* Prometheus Alert Rules
* Grafana Alerting
* Persistente Monitoring-Daten
* Zusätzliche Dashboards
* Cloud Infrastructure Monitoring
* Integration mit CI/CD Pipelines

---

## 📌 Projektstatus

Dieses Labor ist ein abgeschlossenes praktisches Monitoring- und Observability-Projekt.

Die Umgebung demonstriert erfolgreich Container Monitoring mit cAdvisor, Metrics Collection mit Prometheus und Metrics Visualization mit Grafana.

Das Labor kann zukünftig um zusätzliche Exporter, Alerting, Dashboards und Cloud-Monitoring-Szenarien erweitert werden.
