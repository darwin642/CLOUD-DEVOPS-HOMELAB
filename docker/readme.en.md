# 🐳 Docker Application & Containerization Lab

Practical Docker laboratory built to develop hands-on skills in containerization, application deployment, networking, storage, Docker Compose, CI/CD, and container security.

The lab focuses on building, configuring, testing, troubleshooting, automating, and securing containerized applications in a realistic DevOps environment.

---

## 📌 Project Overview

This laboratory covers the deployment and management of containerized applications using Docker.

The project includes:

* Docker Images
* Docker Containers
* Dockerfiles
* Container lifecycle management
* Port mapping
* Bind mounts
* Named volumes
* Docker networks
* Container-to-container communication
* Docker Compose
* Multi-container applications
* PostgreSQL persistence
* Healthchecks
* Multi-stage builds
* Nginx reverse proxy
* Resource limits
* Logging
* Restart policies
* Docker Hub
* Manual CI/CD
* Semantic versioning
* Container security
* Vulnerability scanning

---

## 🏗️ Architecture

### Architecture Diagram

The main application environment consists of an Nginx reverse proxy, a backend application, and a PostgreSQL database running as separate containers.

The application uses Docker networking for service-to-service communication and a persistent volume for database storage.

Here's the diagram;

![Docker Architecture](docker_diagram.jpg)

```text
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

Docker images were created and managed as the base artifacts for container deployment.

The laboratory included working with official images as well as building custom application images from Dockerfiles.

### Configuration

| Resource              | Configuration             |
| --------------------- | ------------------------- |
| Base Image            | `nginx:alpine`            |
| Application Image     | `my-web:v1` / `my-web:v2` |
| Backend Image         | `my-backend:v1`           |
| Registry              | Docker Hub                |
| Docker Hub Repository | `darwin642/my-web`        |

### 📸 Screenshot 01 — Docker Images

![Docker Images](01-docker-images.png)

### 📸 Screenshot 02 — Custom Docker Image

![Custom Docker Image](02-custom-image.png)

### 📸 Screenshot 03 — Docker Image History

![Docker Image History](03-image-history.png)

---

## 2. 📦 Docker Containers

Docker containers were created, started, stopped, inspected, and removed to demonstrate the container lifecycle.

Multiple Nginx containers were deployed during the laboratory exercises.

### Configuration

| Container | Image          | Port   |
| --------- | -------------- | ------ |
| `web01`   | `nginx:alpine` | `8080` |
| `web02`   | `my-web:v1`    | `8081` |
| `web03`   | `my-web:v2`    | `8082` |

### 📸 Screenshot 04 — Running Containers

![Running Containers](04-running-containers.png)

### 📸 Screenshot 05 — Container Details

![Container Details](05-container-details.png)

### 📸 Screenshot 06 — Container Lifecycle

![Container Lifecycle](06-container-lifecycle.png)

---

## 3. 🐳 Dockerfile & Application Containerization

A custom application image was built using a Dockerfile.

The Dockerfile was used to define the application environment, working directory, dependencies, files, and startup command.

The application was then packaged into a Docker image and deployed as a container.

### 📸 Screenshot 07 — Dockerfile

![Dockerfile](07-dockerfile.png)

### 📸 Screenshot 08 — Docker Build

![Docker Build](08-docker-build.png)

### 📸 Screenshot 09 — Containerized Application

![Containerized Application](09-containerized-application.png)

---

## 4. 🔌 Port Mapping

Docker port mapping was configured to expose containerized applications to the host system.

The laboratory used different host ports to run multiple application containers simultaneously.

### Configuration

| Container | Container Port | Host Port |
| --------- | -------------- | --------- |
| `web01`   | `80`           | `8080`    |
| `web02`   | `80`           | `8081`    |
| `web03`   | `80`           | `8082`    |

### 📸 Screenshot 10 — Port Mapping

![Port Mapping](10-port-mapping.png)

### 📸 Screenshot 11 — Application Access

![Application Access](11-application-access.png)

---

## 5. 💾 Volumes & Bind Mounts

Docker storage was tested using both named volumes and bind mounts.

A named volume was used to provide persistent container storage, while a bind mount was used to map a host directory into a container.

### Configuration

| Storage Type   | Example                  |
| -------------- | ------------------------ |
| Named Volume   | `nginx-data`             |
| Bind Mount     | `E:\docker\compose-demo` |
| Container Path | `/usr/share/nginx/html`  |

### 📸 Screenshot 12 — Docker Volume

![Docker Volume](12-docker-volume.png)

### 📸 Screenshot 13 — Volume Mount

![Volume Mount](13-volume-mount.png)

### 📸 Screenshot 14 — Bind Mount

![Bind Mount](14-bind-mount.png)

---

## 6. 🌐 Docker Networks

A custom Docker bridge network was created to allow containers to communicate using Docker's internal networking and service names.

Container-to-container communication was tested successfully.

### Configuration

| Resource           | Configuration          |
| ------------------ | ---------------------- |
| Network            | `app-network`          |
| Network Type       | Bridge                 |
| Communication      | Container-to-container |
| Service Resolution | Docker DNS             |

The backend containers were able to communicate using container/service names instead of host IP addresses.

### 📸 Screenshot 15 — Docker Network

![Docker Network](15-docker-network.png)

### 📸 Screenshot 16 — Network Containers

![Network Containers](16-network-containers.png)

### 📸 Screenshot 17 — Container-to-Container Communication

![Container-to-Container Communication](17-container-communication.png)

---

## 7. 🧩 Docker Compose

Docker Compose was used to define and manage a multi-container application environment.

The Compose environment included a backend application and PostgreSQL database with persistent storage and health monitoring.

### Configuration

| Service    | Purpose                     |
| ---------- | --------------------------- |
| Backend    | Application service         |
| PostgreSQL | Database                    |
| Nginx      | Reverse proxy               |
| Volume     | Persistent database storage |
| Network    | Service communication       |

Environment variables were also used to configure the application and database services.

### 📸 Screenshot 18 — Docker Compose File

![Docker Compose](18-compose-file.png)

### 📸 Screenshot 19 — Compose Services

![Compose Services](19-compose-services.png)

### 📸 Screenshot 20 — Compose Application

![Compose Application](20-compose-application.png)

---

## 8. 🗄️ PostgreSQL & Persistent Application Data

A PostgreSQL container was integrated into the multi-container application environment.

The database used a named Docker volume to preserve data independently from the container lifecycle.

The application was tested by recreating containers while preserving the database volume.

### Configuration

| Resource         | Configuration        |
| ---------------- | -------------------- |
| Database         | PostgreSQL           |
| Image            | `postgres:16-alpine` |
| Database Volume  | `postgres-data`      |
| Database Port    | `5432`               |
| Database Network | `production-network` |

### 📸 Screenshot 21 — PostgreSQL Container

![PostgreSQL Container](21-postgresql-container.png)

### 📸 Screenshot 22 — PostgreSQL Volume

![PostgreSQL Volume](22-postgresql-volume.png)

### 📸 Screenshot 23 — Persistent Data

![Persistent Data](23-persistent-data.png)

---

## 9. 🩺 Healthchecks & Service Dependencies

Docker healthchecks were configured to verify the availability of the PostgreSQL database.

The backend service was configured to wait for the database healthcheck before starting.

### Configuration

```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U appuser -d appdb"]
  interval: 5s
  timeout: 2s
  retries: 5
```

The application stack was tested by bringing the services up and verifying that the backend became available after the database was healthy.

### 📸 Screenshot 24 — PostgreSQL Healthcheck

![Healthcheck](24-healthcheck.png)

### 📸 Screenshot 25 — Service Health

![Service Health](25-service-health.png)

---

## 10. 🔀 Nginx Reverse Proxy

Nginx was configured as a reverse proxy in front of the backend application.

The reverse proxy forwards incoming HTTP requests to the backend container through the Docker network.

### Configuration

| Setting         | Value     |
| --------------- | --------- |
| Proxy           | Nginx     |
| External Port   | `8080`    |
| Backend Port    | `5000`    |
| Backend Service | `backend` |

The backend service was intentionally not exposed directly to the host. Nginx provides the external entry point.

### 📸 Screenshot 26 — Nginx Configuration

![Nginx Configuration](26-nginx-config.png)

### 📸 Screenshot 27 — Reverse Proxy Stack

![Reverse Proxy](27-reverse-proxy.png)

### 📸 Screenshot 28 — HTTP 200 Response

![HTTP Response](28-http-response.png)

---

## 11. 🏗️ Multi-Stage Docker Build

A multi-stage Dockerfile was created to separate the build environment from the final runtime image.

The final image contains only the required runtime components, reducing unnecessary image content.

### 📸 Screenshot 29 — Multi-Stage Dockerfile

![Multi-Stage Dockerfile](29-multistage-dockerfile.png)

### 📸 Screenshot 30 — Multi-Stage Build

![Multi-Stage Build](30-multistage-build.png)

---

## 12. ⚡ Docker Build Optimization

Docker build optimization techniques were applied to improve image construction and reduce unnecessary build data.

The project used:

* `.dockerignore`
* Layer-aware Dockerfile ordering
* `pip --no-cache-dir`
* Alpine-based images
* Multi-stage builds
* Docker build cache

### 📸 Screenshot 31 — Dockerignore

![Dockerignore](31-dockerignore.png)

### 📸 Screenshot 32 — Optimized Dockerfile

![Optimized Dockerfile](32-optimized-dockerfile.png)

---

## 13. 📊 Resource Limits

Container resource limits were tested to demonstrate CPU and memory control.

### Configuration

| Resource     | Configuration |
| ------------ | ------------- |
| CPU Limit    | `500m`        |
| Memory Limit | `128Mi`       |

Resource constraints were used to prevent a container from consuming unlimited host resources.

### 📸 Screenshot 33 — Resource Limits

![Resource Limits](33-resource-limits.png)

### 📸 Screenshot 34 — Docker Stats

![Docker Stats](34-docker-stats.png)

---

## 14. 📝 Logging & Restart Policies

Docker container logs were inspected and filtered during troubleshooting.

Restart policies were also configured to demonstrate automatic container recovery.

### Configuration

* `docker logs`
* `grep` log filtering
* `tail` log inspection
* Container restart policies

### 📸 Screenshot 35 — Container Logs

![Container Logs](35-container-logs.png)

### 📸 Screenshot 36 — Restart Policy

![Restart Policy](36-restart-policy.png)

---

## 15. 🔄 Manual CI/CD Pipeline

A manual CI/CD pipeline was implemented using Docker and PowerShell.

The pipeline automatically builds the application image, starts a temporary test container, verifies the HTTP response, tags the image, and pushes it to Docker Hub.

### Pipeline

```text
Code
  ↓
Build
  ↓
Test
  ↓
Tag
  ↓
Push
  ↓
Deploy
```

The automated PowerShell pipeline performs:

* Docker image build
* Temporary container deployment
* HTTP health test
* Test container cleanup
* Docker image tagging
* Docker Hub push

### 📸 Screenshot 37 — CI/CD Script

![CI/CD Script](37-cicd-script.png)

### 📸 Screenshot 38 — CI/CD Build & Test

![CI/CD Build and Test](38-cicd-build-test.png)

### 📸 Screenshot 39 — CI/CD Pipeline Success

![CI/CD Pipeline Success](39-cicd-success.png)

---

## 16. 📦 Docker Hub & Image Registry

Docker images were published to Docker Hub and pulled back into the local environment to simulate a registry-based deployment workflow.

### Configuration

| Resource    | Configuration      |
| ----------- | ------------------ |
| Registry    | Docker Hub         |
| Repository  | `darwin642/my-web` |
| Example Tag | `backend-v1`       |

The image was pushed to the registry, removed locally, pulled again, and deployed successfully.

### 📸 Screenshot 40 — Docker Hub Repository

![Docker Hub Repository](40-docker-hub.png)

### 📸 Screenshot 41 — Docker Push

![Docker Push](41-docker-push.png)

### 📸 Screenshot 42 — Docker Pull

![Docker Pull](42-docker-pull.png)

---

## 17. 🔢 Semantic Versioning

Semantic versioning was applied to container image releases.

### Versioning

```text
1.0.0 → Initial release
1.0.1 → Patch
1.1.0 → Backward-compatible feature
2.0.0 → Breaking change
```

Docker image tags were used to distinguish application versions during deployment.

### 📸 Screenshot 43 — Image Tags

![Image Tags](43-image-tags.png)

---

## 18. 🔐 Docker Security

Container security practices were implemented to reduce unnecessary privileges and improve image security.

The backend container was configured to run as a non-root user.

Additional security practices included:

* Non-root container user
* Read-only configuration mounts
* Docker secrets
* `.dockerignore`
* Image vulnerability scanning
* Minimal base images

### 📸 Screenshot 44 — Non-Root User

![Non-Root User](44-non-root.png)

### 📸 Screenshot 45 — Docker Secrets

![Docker Secrets](45-docker-secrets.png)

### 📸 Screenshot 46 — Vulnerability Scan

![Vulnerability Scan](46-vulnerability-scan.png)

---

## 19. 🧪 Testing & Troubleshooting

The Docker environment was tested through practical troubleshooting scenarios.

Testing included:

* Container lifecycle management
* Port mapping
* Volume persistence
* Bind mount behavior
* Container networking
* Container-to-container communication
* Docker Compose deployment
* PostgreSQL persistence
* Healthchecks
* Nginx reverse proxy
* Container resource usage
* Container logs
* Restart policies
* Image pull and deployment
* CI/CD validation
* Container security
* Vulnerability scanning

The production Compose application was successfully deployed and tested through the Nginx reverse proxy.

```text
localhost:8080
      ↓
Nginx :80
      ↓
Backend :5000
      ↓
PostgreSQL :5432
      ↓
postgres-data
```

The final HTTP response returned successfully through the reverse proxy.

### 📸 Screenshot 47 — Production Stack

![Production Stack](47-production-stack.png)

### 📸 Screenshot 48 — Production HTTP Test

![Production HTTP Test](48-production-http-test.png)

### 📸 Screenshot 49 — Container Status

![Container Status](49-container-status.png)

---

## 🛠️ Technologies

**Containerization**

Docker · Docker Compose · Dockerfile

**Containers**

Nginx · Python · PostgreSQL

**Networking**

Docker Bridge Networks · Container DNS · Port Mapping · Reverse Proxy

**Storage**

Docker Volumes · Bind Mounts

**CI/CD**

PowerShell · Docker Build · Docker Hub · Automated Testing

**Security**

Non-root Containers · Docker Secrets · `.dockerignore` · Vulnerability Scanning

**Application**

Flask · PostgreSQL · Nginx

**Operating System**

Windows 11 · WSL2

---

## 📚 Skills Demonstrated

* Docker containerization
* Docker image management
* Dockerfile development
* Application containerization
* Container lifecycle management
* Port mapping
* Docker networking
* Container-to-container communication
* Docker DNS
* Docker volumes
* Bind mounts
* Docker Compose
* Multi-container application deployment
* PostgreSQL containerization
* Persistent application data
* Healthchecks
* Nginx reverse proxy
* Multi-stage Docker builds
* Docker build optimization
* Container resource management
* Docker logging
* Restart policies
* Docker Hub
* Manual CI/CD
* Semantic versioning
* Container security
* Vulnerability scanning
* DevOps automation
* Application troubleshooting

---

## 🚀 Next Steps

Planned extensions to the Docker laboratory:

* Kubernetes container orchestration
* Kubernetes Deployments and Services
* Kubernetes networking
* Kubernetes persistent storage
* Kubernetes security
* Helm-based application deployment
* Cloud container deployments
* Advanced CI/CD automation

---

## 📌 Project Status

This laboratory is an ongoing practical containerization and DevOps project.

The environment has been expanded from basic Docker containers into multi-container application deployment, persistent storage, networking, reverse proxy architecture, CI/CD automation, image registries, and container security.

The Docker laboratory provides the foundation for the Kubernetes and cloud infrastructure projects in this repository.
