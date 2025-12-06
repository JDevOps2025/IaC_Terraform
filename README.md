# Terraform Mini-Network Assignment

This repository contains an individual Terraform project implementing a mini-network in AWS to host a simple highly-available web application, as specified in the CA2 Lab 2 Terraform assignment brief.

## Assignment Overview

The goal is to bring Infrastructure as Code (IaC) concepts together in a small but realistic business scenario by designing and deploying a networked application across multiple availability zones using Terraform and AWS best practices. The solution is developed and iteratively improved using GitHub with multiple pull requests to demonstrate continuous improvement and peer-review friendly code changes.

## Learning Outcomes

This project demonstrates the following outcomes from the assignment brief:

- Research and compose solutions to deployment pipeline efficiency issues using IaC.
- Select and justify techniques and technologies to automate infrastructure and job lifecycles.
- Analyse incomplete or weak solutions and propose improved alternatives with clear reasoning.
- Apply coding best practices to enhance teamwork, readability and maintainability.
- Show how scripted pipelines support team-based software delivery.
- Design, implement and test an automated software delivery pipeline using Terraform.
- Review and refactor Terraform scripts to improve quality over time.

## Architecture

The Terraform configuration provisions an AWS VPC-based private cloud similar in spirit to the Kay McNulty Data Centre resources. The network is designed to host a basic web application replicated across availability zones for high availability.

Key elements:

- **VPC**

  - CIDR block: `10.0.0.0/16`.
  - Region: configurable via variables.
  - Two availability zones.

- **Subnets**

  - Public subnets:
    - `10.0.1.0/24`.
    - `10.0.2.0/24`.
  - Private subnets:
    - `10.0.10.0/24`.
    - `10.0.20.0/24`.

- **Web Servers**

  - Two web servers, one in each availability zone.
  - Each instance runs a simple HTTP server (e.g., nginx or Apache HTTPD) serving a basic website.
  - Instances are placed in the public subnets and are registered behind the load balancer.

- **Load Balancing**

  - An Application Load Balancer (ALB) distributes traffic across the web servers for resilience and scalability.

- **Networking**

  - Internet Gateway attached to the VPC for outbound/inbound internet connectivity where appropriate.
  - Route tables configured for public and private subnets following AWS best practices.
  - Specific attention is paid to correct CIDR ranges and routes, improving on the weak example pseudocode in the brief (e.g., avoiding incorrect `0.0.0.0/24` routes and using `0.0.0.0/0` properly with the Internet Gateway).

- **Security Groups**
  - Security groups act as firewalls controlling inbound and outbound traffic.
  - Inbound: restrict to required ports (e.g., HTTP/HTTPS) and limited source CIDRs.
  - Outbound: allow necessary egress while avoiding overly permissive rules where possible.

## Scenario

To ground the architecture, the network hosts a simple demo website running on each web server instance, representing a small startup application that must remain available even if one availability zone fails. The site is intentionally simple so the main focus remains on Terraform, networking, and best practices rather than application complexity.

## Repository Structure

A typical structure for this repository is:

- `main.tf` – core resources (VPC, subnets, IGW, ALB, EC2 instances, security groups).
- `variables.tf` – input variables such as region, instance types, and CIDR blocks.
- `outputs.tf` – useful outputs (e.g., ALB DNS name, instance IPs).
- `modules/` – optional modules if the configuration is broken into reusable components.
- `docs/` – screenshots and final lab write-up as required by the assignment brief.

Comments throughout the code explain key design decisions, trade-offs, and how they align with the assignment requirements and best practices.

## Getting Started

'''bash

1. Install Terraform and configure AWS credentials locally.
2. Clone this repository:

git clone <your-repo-url>.git
cd <repo-name>

3. Review and, if required, update variables in `variables.tf`.
4. Initialize Terraform:

terraform init

5. Review the planned changes:

terraform plan

6. Apply the configuration:

terraform apply

7. After apply completes, use the ALB DNS output to access the sample web application in a browser.
   '''
