variable login          { }
variable password       { }
variable vip            { }
variable vcpu           { }
variable mem            { }
variable ip             { }
variable hostname       { }
variable image          { }
variable nic            { }
variable description    { }
variable vm_name        { }
variable vm_password    { }

terraform {
  required_providers {
    nutanix = {
      source = "nutanix/nutanix"
      version = "1.2.1"
    }
  }
}

provider "nutanix" {
  username = var.login
  password = var.password
  endpoint = var.vip
  insecure = true
  port     = 9440
}

data "nutanix_clusters" "clusters" {}
locals {
     cluster_uuid = [
        for cluster in data.nutanix_clusters.clusters.entities :
        cluster.metadata.uuid if cluster.service_list[0] != "PRISM_CENTRAL"
        ][0]
}

data "nutanix_subnet" "network" {
    subnet_name = var.nic
}

data "nutanix_image" "image" {
    image_name = var.image
}

data "template_file" "cloud"{
        template = file("cloud-init")
        vars = {
                vm_name = var.vm_name
                vm_password = var.vm_password
        }
}

#change count to deploy number of VMs
resource "nutanix_virtual_machine" "terraform-deploy" {
 name = var.hostname
 description = var.description
 num_vcpus_per_socket = var.vcpu
 num_sockets          = 1
 memory_size_mib      = var.mem * 1024
 guest_customization_cloud_init_user_data = base64encode("${(data.template_file.cloud.rendered)}")
 cluster_uuid = local.cluster_uuid

nutanix_guest_tools = {
        state = "ENABLED"
}

nic_list {
  subnet_uuid = data.nutanix_subnet.network.id
   ip_endpoint_list {
        ip = var.ip
        type = "ASSIGNED"
        }
  }

disk_list {
   data_source_reference = {
     kind = "image"
     uuid = data.nutanix_image.image.id
       }
       }

}
