# Azure Compliance Automation Engine

Automated Azure Policy compliance detection using PowerShell, 
Azure Resource Graph, and Azure Functions.

## Architecture
Azure Policy → Azure Resource Graph (KQL) → Azure Storage Queue 
→ Azure Function → PowerShell Remediation → Log Analytics

## What It Does
- Custom Azure Policy detects resources missing required tags
- ARG KQL query scans subscription for non-compliant resources
- PowerShell script queues non-compliant resourceIds for remediation
- GitHub Actions CI/CD pipeline deploys automatically on push

## Tech Stack
- PowerShell, Azure Resource Graph, KQL
- Azure Policy, Azure Functions, Azure Storage Queue
- GitHub Actions, Service Principal, Managed Identity

## Project Status
Detection and policy layer complete. 
Remediation function in progress.
