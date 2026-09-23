# Terraform

## Overview

This section documents the use of **Terraform** to manage cloud infrastructure as code across both **Microsoft Azure**, **Google Cloud Platform** and **Amazon Web Services (AWS)**.

The Terraform configurations include the infrastructure, networking, security, identity, monitoring, backup, and other cloud resources used throughout the labs.

Because the Terraform content is too large to fit cleanly into a single page, the documentation has been divided into **three separate pages**.

---

## Documentation

### Azure Terraform

The first page covers the Terraform implementation for the **Azure environment**, including the configuration files, infrastructure resources, and deployment structure.

➡️ **[Azure Terraform Documentation](az/readme.en.md)**

### AWS Terraform

The second page covers the Terraform implementation for the **AWS environment**, including its Terraform configuration and managed infrastructure.

➡️ **[AWS Terraform Documentation](aws/readme.en.md)**

## GCP Terraform

The third page covers the Terraform implementation for the GCP environment, including the imported infrastructure, Terraform state management, drift detection, and configuration validation.

➡️ **[GCP Terraform Documentation](gcp/readme.en.md)**

---

## Why Terraform?

Terraform provides a consistent and repeatable way to define and manage cloud infrastructure using code.

Instead of manually configuring resources through cloud consoles, infrastructure can be defined in Terraform configuration files and deployed through a controlled workflow.

This project uses Terraform to demonstrate practical **Infrastructure as Code (IaC)** skills across multiple cloud platforms.
