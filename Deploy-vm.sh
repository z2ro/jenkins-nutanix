#!/bin/bash

read -p "Login: " T_USER
read -s -p "Password: " T_PASS; echo
read -p "VIP: " T_VIP
read -p "vCPU: " T_VCPU
read -p "MEM: " T_MEM
read -p "IP: " T_IP
read -p "HOSTNAME: " T_HOSTNAME
read -p "IMAGE: " T_IMAGE
read -p "NIC: " T_NIC
read -p "DESC: " T_DESC
read -p "VM Name: " T_VMN
read -s -p "VM Pass: " T_VMP

echo "login=\"$T_USER\"" > vars.tfvars
echo "password=\"$T_PASS\"" >> vars.tfvars
echo "vip=\"$T_VIP\"" >> vars.tfvars
echo "vcpu=\"$T_VCPU\"" >> vars.tfvars
echo "mem=\"$T_MEM\"" >> vars.tfvars
echo "ip=\"$T_IP\"" >> vars.tfvars
echo "hostname=\"$T_HOSTNAME\"" >> vars.tfvars
echo "image=\"$T_IMAGE\"" >> vars.tfvars
echo "nic=\"$T_NIC\"" >> vars.tfvars
echo "description=\"$T_DESC\"" >> vars.tfvars
echo "vm_name=\"$T_VMN\"" >> vars.tfvars
echo "vm_password=\"$T_VMP\"" >> vars.tfvars

terraform plan -out=tfplan -input=false -var-file=vars.tfvars
terraform apply -input=false tfplan
rm -rf terraform.tfstate
