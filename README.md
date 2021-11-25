# Jenkins pipeline for nutanix

A repository for a Nutanix pipeline with Jenkins. 

## Commands

* **Plan**

terraform plan -out=tfplan -input=false -var-file=vars.tfvars

## Getting Started
  1. Create a Jenkins Pipeline
  2. Install terraform 1.0.11 on jenkins VM
  3. Put the pipeline-nutanix-deploy-vm.jenkinsfile code and edit with your parameters
  4. The main.tf file is the terraform main file.
  5. Enjoy 
