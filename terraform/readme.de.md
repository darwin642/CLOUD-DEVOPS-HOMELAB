# Terraform

## Überblick

Dieser Abschnitt dokumentiert die Verwendung von **Terraform** zur Verwaltung von Cloud-Infrastrukturen als Code über **Microsoft Azure**, **Google Cloud Platform** und **Amazon Web Services (AWS)** hinweg.

Die Terraform-Konfigurationen umfassen die Infrastruktur, Netzwerke, Sicherheit, Identität, Überwachung, Backups und weitere Cloud-Ressourcen, die in den Labs verwendet werden.

Da der Terraform-Inhalt zu umfangreich ist, um übersichtlich auf einer einzigen Seite dargestellt zu werden, wurde die Dokumentation auf **drei separate Seiten** aufgeteilt.

---

## Dokumentation

### Azure Terraform

Die erste Seite behandelt die Terraform-Implementierung für die **Azure-Umgebung**, einschließlich der Konfigurationsdateien, Infrastrukturressourcen und Bereitstellungsstruktur.

➡️ **[Azure Terraform-Dokumentation](az/readme.de.md)**

### AWS Terraform

Die zweite Seite behandelt die Terraform-Implementierung für die **AWS-Umgebung**, einschließlich der Terraform-Konfiguration und der verwalteten Infrastruktur.

➡️ **[AWS Terraform-Dokumentation](aws/readme.de.md)**

## GCP Terraform

Die dritte Seite behandelt die Terraform-Implementierung für die **GCP-Umgebung**, einschließlich der importierten Infrastruktur, der Verwaltung des Terraform-States, der Erkennung von Abweichungen (Drift Detection) und der Validierung der Konfiguration.

➡️ **[GCP Terraform-Dokumentation](gcp/readme.de.md)**

---

## Warum Terraform?

Terraform bietet eine konsistente und wiederholbare Möglichkeit, Cloud-Infrastrukturen mithilfe von Code zu definieren und zu verwalten.

Anstatt Ressourcen manuell über Cloud-Konsolen zu konfigurieren, kann die Infrastruktur in Terraform-Konfigurationsdateien definiert und über einen kontrollierten Workflow verwaltet werden.

Dieses Projekt verwendet Terraform, um praktische **Infrastructure-as-Code-(IaC)-Kenntnisse** über mehrere Cloud-Plattformen hinweg zu demonstrieren.
