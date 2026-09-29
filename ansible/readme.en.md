# ⚙️ Ansible Configuration Management Lab

A practical Ansible configuration management laboratory created to develop hands-on skills in Linux system administration, service management, automation, firewall configuration, templating, and idempotent infrastructure management.

The main goal of this laboratory is to automate common Linux configuration tasks using reusable Ansible roles instead of managing services and configuration manually.

---

## 📌 Project Overview

This laboratory demonstrates a role-based Ansible configuration management environment.

The project covers the following areas:

* Ansible Playbooks
* Ansible Roles
* Inventory management
* Package installation
* Service management
* Jinja2 Templates
* Handlers
* `notify`
* Privilege escalation with `become`
* UFW Firewall
* OpenSSH
* Nginx
* Idempotent configuration
* Configuration verification

---

## 🏗️ Architecture

### Project Structure

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

The laboratory uses a local Linux environment and manages the system through Ansible's local connection.

The configuration is separated into reusable roles to keep the playbook modular and easier to maintain.

### 📸 Screenshot 01 — Ansible Project Structure

![Ansible Project Structure](01-project-structure.png)

---

## 1. 📋 Inventory & Playbook

The Ansible inventory defines the managed host, while the main playbook controls which roles are applied.

### Configuration

| File          | Purpose                  |
| ------------- | ------------------------ |
| `hosts.ini`   | Defines the managed host |
| `site.yml`    | Main Ansible playbook    |
| `ansible.cfg` | Ansible configuration    |

The playbook applies the following roles:

* `common`
* `webserver`
* `firewall`

### 📸 Screenshot 02 — Inventory

![Inventory](02-inventory.png)

### 📸 Screenshot 03 — Main Playbook

![Main Playbook](03-site-yml.png)

---

## 2. 🧩 Ansible Roles

The configuration was divided into separate Ansible roles to demonstrate modular configuration management.

### Common Role

The `common` role manages the OpenSSH service.

It handles:

* OpenSSH package installation
* SSH service management
* Service enablement

### Webserver Role

The `webserver` role manages the Nginx web server.

It handles:

* Nginx installation
* Nginx service management
* Service enablement
* Website configuration
* Jinja2 template deployment
* Nginx restart through a handler

### Firewall Role

The `firewall` role manages the UFW firewall.

It handles:

* UFW installation
* SSH access on TCP/22
* HTTP access on TCP/80
* Firewall enablement

### 📸 Screenshot 04 — Ansible Roles

![Ansible Roles](04-roles.png)

---

## 3. 🌐 Nginx Web Server

Nginx was deployed and configured automatically through the `webserver` role.

The configuration uses a Jinja2 template instead of manually modifying the web server files.

### Configuration

| Service       | Configuration   |
| ------------- | --------------- |
| Web Server    | Nginx           |
| HTTP Port     | `80`            |
| Configuration | Jinja2 Template |
| Management    | Ansible         |

The resulting web page was verified using a local HTTP request.

### 📸 Screenshot 05 — Nginx Service

![Nginx Service](05-nginx-service.png)

### 📸 Screenshot 06 — Nginx Web Page

![Nginx Web Page](06-nginx-web-page.png)

---

## 4. 🔥 UFW Firewall

UFW was configured through the `firewall` Ansible role.

### Configuration

| Rule | Port | Protocol |
| ---- | ---- | -------- |
| SSH  | `22` | TCP      |
| HTTP | `80` | TCP      |

The firewall was enabled and verified after the playbook execution.

### 📸 Screenshot 07 — UFW Status

![UFW Status](07-ufw-status.png)

---

## 5. 🔔 Templates & Handlers

The laboratory demonstrates how Ansible handlers can be triggered when a configuration changes.

The Nginx website configuration is deployed through a template.

When the template changes, the task uses `notify` to trigger the Nginx restart handler.

### Workflow

```text
Jinja2 Template
      │
      ▼
Configuration Changed
      │
      ▼
    notify
      │
      ▼
Nginx Restart Handler
```

The handler only runs when the task reports a change.

### 📸 Screenshot 08 — Template Configuration

![Template Configuration](08-template.png)

### 📸 Screenshot 09 — Handler Execution

![Handler Execution](09-handler.png)

---

## 6. 🔐 Privilege Escalation

Ansible's `become` mechanism was used for tasks that require administrative privileges.

This allows Ansible to manage system-level resources without manually running every command as root.

Administrative tasks include:

* Package installation
* Service management
* Firewall configuration
* Protected system files

### 📸 Screenshot 10 — Become Configuration

![Become Configuration](10-become.png)

---

## 7. 🔄 Idempotency

Idempotency was tested by running the Ansible playbook multiple times.

The first execution applies the required configuration and reports changes.

A second execution against the same system should report:

```text
changed=0
```

This demonstrates that Ansible does not repeatedly modify resources that already match the desired state.

### 📸 Screenshot 11 — First Playbook Run

![First Playbook Run](11-first-run.png)

### 📸 Screenshot 12 — Idempotent Second Run

![Idempotent Second Run](12-second-run.png)

---

## 8. 🧪 Testing & Verification

The final configuration was verified through service, firewall, and web server checks.

Tests included:

* Nginx service status
* SSH service status
* UFW firewall status
* HTTP connectivity
* Ansible playbook execution
* Handler execution
* Idempotency verification
* Role-based configuration

### Verification Commands

```bash
systemctl status nginx
systemctl status ssh
sudo ufw status
curl http://localhost
```

### 📸 Screenshot 13 — Service Verification

![Service Verification](13-service-verification.png)

### 📸 Screenshot 14 — HTTP Connectivity Test

![HTTP Connectivity Test](14-http-test.png)

---

## 🛠️ Technologies

**Configuration Management**

Ansible

**Operating System**

Linux

**Web Server**

Nginx

**Firewall**

UFW

**Services**

OpenSSH · systemd

**Configuration**

YAML · Jinja2

**Automation Concepts**

Roles · Playbooks · Templates · Handlers · `notify` · `become` · Idempotency

---

## 📚 Skills Demonstrated

* Ansible configuration management
* Role-based automation
* Playbook development
* Inventory management
* Linux system administration
* Package management
* Service management
* Nginx configuration
* UFW firewall configuration
* Jinja2 templating
* Ansible handlers
* `notify` usage
* Privilege escalation with `become`
* Idempotent configuration
* Infrastructure automation
* Configuration troubleshooting

---

## 🚀 Next Steps

Planned improvements for the Ansible laboratory:

* Managing multiple Linux hosts
* Remote host configuration
* Dynamic inventory
* Ansible Vault
* More reusable roles
* Cloud infrastructure automation
* Integration with CI/CD pipelines
* Ansible integration with Terraform

---

## 📌 Project Status

This laboratory is a completed hands-on Ansible configuration management project.

The environment successfully demonstrates role-based configuration, service management, firewall automation, templating, handlers, privilege escalation, and idempotent configuration.

The laboratory may continue to evolve with additional automation and cloud infrastructure scenarios.
