# ⚙️ Ansible Configuration Management Lab

Ein praxisorientiertes Ansible-Labor, das praktische Kenntnisse in Linux-Systemadministration, Service Management, Automatisierung, Firewall-Konfiguration, Templating und idempotenter Infrastrukturverwaltung vermittelt.

Das Hauptziel dieses Labors besteht darin, typische Linux-Konfigurationsaufgaben mit wiederverwendbaren Ansible-Rollen zu automatisieren, anstatt Services und Konfigurationen manuell zu verwalten.

---

## 📌 Projektübersicht

Dieses Labor demonstriert eine rollenbasierte Ansible-Umgebung für Configuration Management.

Das Projekt umfasst folgende Bereiche:

* Ansible Playbooks
* Ansible Roles
* Inventory Management
* Paketinstallation
* Service Management
* Jinja2 Templates
* Handler
* `notify`
* Privilege Escalation mit `become`
* UFW Firewall
* OpenSSH
* Nginx
* Idempotente Konfiguration
* Konfigurationsüberprüfung

---

## 🏗️ Architektur

### Projektstruktur

```text
ansible-lab/
│
├── ansible.cfg
├── hosts.ini
├── site.yml
│
└── roles/
    ├── common/
    │   ├── tasks/
    │   └── handlers/
    │
    ├── webserver/
    │   ├── tasks/
    │   ├── handlers/
    │   └── templates/
    │
    └── firewall/
        └── tasks/
```

Das Labor verwendet eine lokale Linux-Umgebung und verwaltet das System über Ansible mit einer lokalen Verbindung.

Die Konfiguration ist in wiederverwendbare Rollen aufgeteilt, um das Playbook modular und leichter wartbar zu halten.

### 📸 Screenshot 01 — Ansible Projektstruktur

![Ansible Projektstruktur](01-project-structure.png)

---

## 1. 📋 Inventory & Playbook

Das Ansible Inventory definiert den verwalteten Host, während das Haupt-Playbook festlegt, welche Rollen angewendet werden.

### Konfiguration

| Datei         | Zweck                          |
| ------------- | ------------------------------ |
| `hosts.ini`   | Definiert den verwalteten Host |
| `site.yml`    | Haupt-Ansible-Playbook         |
| `ansible.cfg` | Ansible-Konfiguration          |

Das Playbook verwendet folgende Rollen:

* `common`
* `webserver`
* `firewall`

### 📸 Screenshot 02 — Inventory

![Inventory](02-inventory.png)

### 📸 Screenshot 03 — Haupt-Playbook

![Haupt-Playbook](03-site-yml.png)

---

## 2. 🧩 Ansible Roles

Die Konfiguration wurde in separate Ansible-Rollen aufgeteilt, um ein modulares Configuration Management zu demonstrieren.

### Common Role

Die `common`-Rolle verwaltet den OpenSSH-Service.

Sie übernimmt:

* Installation des OpenSSH-Pakets
* Verwaltung des SSH-Services
* Aktivierung des Services

### Webserver Role

Die `webserver`-Rolle verwaltet den Nginx-Webserver.

Sie übernimmt:

* Installation von Nginx
* Verwaltung des Nginx-Services
* Aktivierung des Services
* Konfiguration der Website
* Bereitstellung von Jinja2-Templates
* Neustart von Nginx über einen Handler

### Firewall Role

Die `firewall`-Rolle verwaltet die UFW-Firewall.

Sie übernimmt:

* Installation von UFW
* SSH-Zugriff über TCP/22
* HTTP-Zugriff über TCP/80
* Aktivierung der Firewall

### 📸 Screenshot 04 — Ansible Roles

![Ansible Roles](04-roles.png)

---

## 3. 🌐 Nginx Webserver

Nginx wurde automatisch über die `webserver`-Rolle bereitgestellt und konfiguriert.

Die Konfiguration verwendet ein Jinja2-Template, anstatt die Webserver-Dateien manuell zu bearbeiten.

### Konfiguration

| Service       | Konfiguration   |
| ------------- | --------------- |
| Webserver     | Nginx           |
| HTTP-Port     | `80`            |
| Konfiguration | Jinja2 Template |
| Verwaltung    | Ansible         |

Die bereitgestellte Webseite wurde anschließend über eine lokale HTTP-Anfrage überprüft.

### 📸 Screenshot 05 — Nginx Service

![Nginx Service](05-nginx-service.png)

### 📸 Screenshot 06 — Nginx Webseite

![Nginx Webseite](06-nginx-web-page.png)

---

## 4. 🔥 UFW Firewall

UFW wurde über die Ansible-`firewall`-Rolle konfiguriert.

### Konfiguration

| Regel | Port | Protokoll |
| ----- | ---- | --------- |
| SSH   | `22` | TCP       |
| HTTP  | `80` | TCP       |

Die Firewall wurde aktiviert und nach der Playbook-Ausführung überprüft.

### 📸 Screenshot 07 — UFW Status

![UFW Status](07-ufw-status.png)

---

## 5. 🔔 Templates & Handler

Das Labor demonstriert, wie Ansible-Handler ausgelöst werden können, wenn sich eine Konfiguration ändert.

Die Nginx-Webseitenkonfiguration wird über ein Template bereitgestellt.

Wenn sich das Template ändert, verwendet der Task `notify`, um den Nginx-Neustart-Handler auszulösen.

### Ablauf

```text
Jinja2 Template
      │
      ▼
Konfiguration geändert
      │
      ▼
    notify
      │
      ▼
Nginx Restart Handler
```

Der Handler wird nur ausgeführt, wenn der entsprechende Task eine Änderung meldet.

### 📸 Screenshot 08 — Template-Konfiguration

![Template-Konfiguration](08-template.png)

### 📸 Screenshot 09 — Handler-Ausführung

![Handler-Ausführung](09-handler.png)

---

## 6. 🔐 Privilege Escalation

Für Aufgaben, die administrative Rechte benötigen, wurde Ansible's `become`-Mechanismus verwendet.

Dadurch kann Ansible systemweite Ressourcen verwalten, ohne jeden Befehl manuell als Root ausführen zu müssen.

Administrative Aufgaben umfassen:

* Paketinstallation
* Service Management
* Firewall-Konfiguration
* Geschützte Systemdateien

### 📸 Screenshot 10 — Become-Konfiguration

![Become-Konfiguration](10-become.png)

---

## 7. 🔄 Idempotenz

Die Idempotenz wurde getestet, indem das Ansible-Playbook mehrfach ausgeführt wurde.

Bei der ersten Ausführung wird die erforderliche Konfiguration angewendet und Änderungen werden gemeldet.

Eine zweite Ausführung auf demselben System sollte Folgendes anzeigen:

```text
changed=0
```

Dies zeigt, dass Ansible Ressourcen nicht wiederholt verändert, wenn sie bereits dem gewünschten Zustand entsprechen.

### 📸 Screenshot 11 — Erster Playbook-Lauf

![Erster Playbook-Lauf](11-first-run.png)

### 📸 Screenshot 12 — Idempotenter zweiter Lauf

![Idempotenter zweiter Lauf](12-second-run.png)

---

## 8. 🧪 Testing & Verification

Die finale Konfiguration wurde durch Überprüfungen der Services, der Firewall und des Webservers verifiziert.

Die Tests umfassten:

* Nginx Service Status
* SSH Service Status
* UFW Firewall Status
* HTTP Connectivity
* Ansible Playbook-Ausführung
* Handler-Ausführung
* Idempotenzprüfung
* Rollenbasierte Konfiguration

### Verifizierungsbefehle

```bash
systemctl status nginx
systemctl status ssh
sudo ufw status
curl http://localhost
```

### 📸 Screenshot 13 — Service-Verifizierung

![Service-Verifizierung](13-service-verification.png)

### 📸 Screenshot 14 — HTTP Connectivity Test

![HTTP Connectivity Test](14-http-test.png)

---

## 🛠️ Technologien

**Configuration Management**

Ansible

**Betriebssystem**

Linux

**Webserver**

Nginx

**Firewall**

UFW

**Services**

OpenSSH · systemd

**Konfiguration**

YAML · Jinja2

**Automatisierungskonzepte**

Roles · Playbooks · Templates · Handler · `notify` · `become` · Idempotenz

---

## 📚 Nachgewiesene Kenntnisse

* Ansible Configuration Management
* Rollenbasierte Automatisierung
* Playbook-Entwicklung
* Inventory Management
* Linux-Systemadministration
* Paketverwaltung
* Service Management
* Nginx-Konfiguration
* UFW-Firewall-Konfiguration
* Jinja2-Templating
* Ansible Handler
* Verwendung von `notify`
* Privilege Escalation mit `become`
* Idempotente Konfiguration
* Infrastrukturautomatisierung
* Konfigurations-Troubleshooting

---

## 🚀 Nächste Schritte

Geplante Erweiterungen für das Ansible-Labor:

* Verwaltung mehrerer Linux-Hosts
* Konfiguration entfernter Hosts
* Dynamic Inventory
* Ansible Vault
* Weitere wiederverwendbare Rollen
* Cloud-Infrastruktur-Automatisierung
* Integration mit CI/CD-Pipelines
* Integration von Ansible mit Terraform

---

## 📌 Projektstatus

Dieses Labor ist ein abgeschlossenes praxisorientiertes Ansible-Configuration-Management-Projekt.

Die Umgebung demonstriert erfolgreich rollenbasierte Konfiguration, Service Management, Firewall-Automatisierung, Templating, Handler, Privilege Escalation und idempotente Konfiguration.

Das Labor kann zukünftig durch weitere Automatisierungs- und Cloud-Infrastruktur-Szenarien erweitert werden.
