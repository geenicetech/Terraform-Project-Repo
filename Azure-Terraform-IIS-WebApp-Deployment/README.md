# Azure Terraform Web App Deployment

A project to deploy a windows server with IIS install and a webapp to display static content with the use of Terraform

## Overview

The project includes Terraform scripts to set up the following components:

- Azure Resource Group
- Azure Storage Account for static content
- Azure Virtual Machine with IIS installed
- Custom Script Extensions to configure IIS and upload a web application

## Prerequisites

Ensure you have the following tools and accounts set up:

- [Terraform](https://www.terraform.io/) installed locally
- An [Azure subscription](https://azure.microsoft.com/en-us/free/) and the Azure CLI configured

- Initialize Terraform and download required providers:
terraform init

Customize variables.tf and terraform.tfvars files with your Azure configuration.

Plan your deployment:
terraform plan

Deploy the infrastructure:
terraform apply

Access the deployed web application:
After successful deployment, to access the web application copy and paste the public IP address of the Azure Virtual Machine in your web browser and hit enter key.

Project Structure
main.tf: Defines the main infrastructure components.
variables.tf: Contains variable declarations.
terraform.tfvars: Input variables with actual values.
scripts/: Contains scripts used by Custom Script Extensions.

Additional Notes
The project deploys a basic web application that displays static content from an Azure Storage Blob.
Custom Script Extensions are used to configure IIS on the Virtual Machine and upload the web application code.


