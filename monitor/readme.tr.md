# 📊 Prometheus & Grafana Monitoring Lab

Prometheus, Grafana, cAdvisor ve Docker kullanılarak oluşturulmuş pratik bir monitoring ve observability laboratuvarıdır.

Bu laboratuvarın temel amacı containerized workload'ları izlemek, altyapı metriklerini toplamak ve sistem ile container performansını Grafana dashboard'ları üzerinden görselleştirmektir.

---

## 📌 Proje Genel Bakış

Bu laboratuvar aşağıdaki teknolojileri kullanarak container tabanlı bir monitoring ortamı oluşturur:

* Prometheus
* Grafana
* cAdvisor
* Docker
* Prometheus exporters ve metrics
* Monitoring dashboard'ları
* Container resource monitoring

Ortam, Cloud ve DevOps alanlarında yaygın olarak kullanılan monitoring konseptleri üzerinde pratik deneyim kazanmak amacıyla oluşturulmuştur.

---

## 🏗️ Mimari

Monitoring stack aşağıdaki bileşenlerden oluşmaktadır:

```text
                    ┌─────────────────────┐
                    │       Grafana       │
                    │  Görselleştirme     │
                    │      Port 3000      │
                    └──────────┬──────────┘
                               │
                               │ Prometheus Data Source
                               ▼
                    ┌─────────────────────┐
                    │     Prometheus      │
                    │  Metrics Storage    │
                    │      Port 9090      │
                    └──────────┬──────────┘
                               │
                         Metrics toplar
                               │
              ┌────────────────┴────────────────┐
              │                                 │
              ▼                                 ▼
     ┌─────────────────┐              ┌─────────────────┐
     │     cAdvisor    │              │     Docker      │
     │ Container Metrics│             │   Container'lar │
     │     Port 8080   │              │                 │
     └─────────────────┘              └─────────────────┘
```

### 📸 Screenshot 01 — Monitoring Mimarisi

![Monitoring Architecture](01-monitoring-architecture.png)

---

## 1. 🐳 Docker Monitoring Ortamı

Monitoring stack Docker container'ları üzerinde çalışmaktadır.

Ortam aşağıdaki bileşenleri içerir:

| Bileşen    | Amaç                       | Port   |
| ---------- | -------------------------- | ------ |
| Prometheus | Metrics toplama ve saklama | `9090` |
| Grafana    | Metrics görselleştirme     | `3000` |
| cAdvisor   | Container resource metrics | `8080` |

Monitoring servislerini yönetmek için Docker Compose kullanılmıştır.

### 📸 Screenshot 02 — Docker Container'ları

![Docker Containers](02-docker-containers.png)

---

## 2. 📈 Prometheus

Prometheus, time-series metrics verilerinin toplanmasından ve saklanmasından sorumludur.

Belirlenen monitoring target'larını düzenli olarak scrape eder ve toplanan metrics verilerini query interface üzerinden erişilebilir hale getirir.

### Prometheus Konfigürasyonu

Prometheus konfigürasyonu monitoring target'larını ve scrape interval değerlerini tanımlar.

Örnek:

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

cAdvisor, container seviyesinde resource ve performance metrics sağlar.

Bu laboratuvarda cAdvisor, Docker container'larını izlemek ve Prometheus tarafından scrape edilebilecek metrics verilerini sağlamak için kullanılmaktadır.

İzlenen bilgiler:

* CPU kullanımı
* Memory kullanımı
* Network trafiği
* Container aktivitesi
* Filesystem kullanımı

### 📸 Screenshot 04 — cAdvisor

![cAdvisor](04-cadvisor.png)

---

## 4. 📊 Grafana

Grafana, Prometheus tarafından toplanan metrics verilerini görselleştirmek için kullanılmaktadır.

Prometheus, Grafana içerisinde Data Source olarak yapılandırılmıştır.

Grafana dashboard ve panel'leri üzerinden metrics verilerinin incelenmesini sağlar.

### 📸 Screenshot 05 — Grafana Dashboard

![Grafana Dashboard](05-grafana-dashboard.png)

---

## 5. 🔗 Prometheus & Grafana Entegrasyonu

Prometheus, Grafana için ana Data Source olarak yapılandırılmıştır.

Entegrasyon akışı:

```text
Docker Container'ları
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

Bu yapı, container metrics verilerinin toplanmasından görselleştirilmesine kadar temel bir monitoring pipeline'ını göstermektedir.

### 📸 Screenshot 06 — Grafana Prometheus Data Source

![Grafana Prometheus Data Source](06-grafana-prometheus-datasource.png)

---

## 6. 📉 Metrics & Görselleştirme

Grafana dashboard'u container performans metrics'lerini görselleştirmek için kullanılmıştır.

Örnek metrics:

* CPU kullanımı
* Memory kullanımı
* Network aktivitesi
* Container resource kullanımı

Dashboard, izlenen ortamın merkezi bir görünümünü sağlar.

### 📸 Screenshot 07 — Container Metrics

![Container Metrics](07-container-metrics.png)

---

## 7. 🧪 Monitoring Doğrulaması

Monitoring stack aşağıdaki kontroller ile doğrulanmıştır:

* Docker container'larının çalıştığının kontrol edilmesi
* Prometheus'a erişimin kontrol edilmesi
* Prometheus target'larının kontrol edilmesi
* cAdvisor'ın metrics sağladığının kontrol edilmesi
* Grafana'ya erişimin kontrol edilmesi
* Grafana'nın Prometheus'a bağlandığının doğrulanması
* Container metrics'lerinin dashboard'larda görüntülenmesi

### Doğrulama

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

### 📸 Screenshot 08 — Monitoring Doğrulaması

![Monitoring Verification](08-monitoring-verification.png)

---

## 🛠️ Teknolojiler

**Monitoring**

Prometheus · Grafana · cAdvisor

**Container**

Docker · Docker Compose

**Metrics**

CPU · Memory · Network · Container Metrics

**Görselleştirme**

Grafana Dashboards

---

## 📚 Gösterilen Yetkinlikler

* Prometheus konfigürasyonu
* Metrics collection
* Time-series monitoring
* Grafana dashboard konfigürasyonu
* Grafana data source yapılandırması
* Container monitoring
* cAdvisor
* Docker Compose
* Infrastructure observability
* Monitoring troubleshooting
* Temel Cloud/DevOps observability uygulamaları

---

## 🚀 Sonraki Adımlar

Planlanan geliştirmeler:

* Node Exporter
* Linux host monitoring
* Alertmanager
* Prometheus alert rules
* Grafana alerting
* Kalıcı monitoring verileri
* Ek dashboard'lar
* Cloud infrastructure monitoring
* CI/CD pipeline entegrasyonu

---

## 📌 Proje Durumu

Bu laboratuvar tamamlanmış bir hands-on monitoring ve observability projesidir.

Ortam; cAdvisor ile container monitoring, Prometheus ile metrics collection ve Grafana ile metrics visualization süreçlerini başarıyla göstermektedir.

Laboratuvar ileride ek exporter'lar, alerting mekanizmaları, dashboard'lar ve cloud monitoring senaryoları ile geliştirilebilir.
