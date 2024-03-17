# AutoBicepSuite

[![deploy-auto-website-suite](https://github.com/nenad0707/AutoBicepSuite/actions/workflows/workflow.yml/badge.svg)](https://github.com/nenad0707/AutoBicepSuite/actions/workflows/workflow.yml)

## 📂 Project Structure

The project consists of the following files and directories:

azureScript.ps1
compute.bicep
main.bicep
main.parameters.json
module/
app-service-plan.bicep
application-insight.bicep
function-app.bicep
storage-account.bicep
README.md

## ⚠️ Note

The Azure resources used in this project are temporary as they are part of an Azure Cloud Sandbox which was purchased temporarily. Please ensure to replace these resources with your own before deploying the project.

![Azure Infrastructure](azure-infrastructure.png "Azure Infrastructure")

This image represents the deployed Azure resources in the project.

## 📄 Main Files

The `main.bicep` and `compute.bicep` files are responsible for setting up the main resources and compute resources for the project, respectively. They define various parameters such as the location, tags, and names of the resources, and they also include modules for deploying these resources.

The `main.parameters.json` file provides the values for these parameters, such as the names of the storage account, application insights resource, app service plan, and function app, as well as the SKU for the storage account and app service plan, and an API key.

The `azureScript.ps1` file is a PowerShell script that sets up Azure contexts, creates Azure AD applications, and assigns the Contributor role to the application. It also writes Azure secrets to the console. This script is essential for setting up the necessary Azure resources and permissions before deploying the resources defined in the `.bicep` files.

## 📁 Module Directory

The `module` directory contains `.bicep` files for each of the resources that are deployed, including the storage account, application insights resource, app service plan, and function app.

## 🚀 GitHub Actions Workflow

The GitHub Actions workflow in [workflow.yml](.github/workflows/workflow.yml) consists of three jobs:

1. **Lint**: This job runs on the latest Ubuntu environment and checks the syntax of your Bicep files by running `az bicep build --file main.bicep`.

2. **Validate**: This job also runs on the latest Ubuntu environment. It signs in to Azure using the provided secrets and performs a preflight validation of your Bicep templates using the `azure/arm-deploy@v1` action. It uses the `main.bicep` file as the template and `main.parameters.json` for the parameters.

3. **Deploy**: This job depends on the successful completion of the `lint` and `validate` jobs. It signs in to Azure and deploys your Bicep templates to the specified resource group using the `azure/arm-deploy@v1` action.

The workflow is triggered on every push to the `main` branch.
