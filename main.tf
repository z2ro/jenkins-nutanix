variable login          { }
variable password       { }
variable vip            { }
variable vcpu           { }
variable mem            { }
variable ip             { }
variable hostname       { }
variable image          { }
variable nic            { }
variable cloud          { }

terraform {
  required_providers {
    nutanix = {
      source = "nutanix/nutanix"
      version = "1.2.1"
    }
  }
}

provider "nutanix" {
  username = "${var.login}"
  password = "${var.password}"
  endpoint = "${var.vip}"
  insecure = true
  port     = 9440
}


data "template_file" "cloud"{
        template = file("cloud-init")
}

#change count to deploy number of VMs
resource "nutanix_virtual_machine" "terraform-deploy" {
 name = "${var.hostname}"
 description = "terraform-deploy"
 num_vcpus_per_socket = "${var.vcpu}"
 num_sockets          = 1
 memory_size_mib      = "${var.mem}"
 guest_customization_cloud_init_user_data = base64encode("${(data.template_file.cloud.template)}")

cluster_uuid = "000553fe-8616-4c8f-0000-0000000161c1"

nutanix_guest_tools = {
        state = "ENABLED"
        iso_mount_state = "MOUNTED"
}

nic_list {
  subnet_uuid = "${var.nic}"
   ip_endpoint_list {
        ip = "${var.ip}"
        type = "ASSIGNED"
        }
  }

disk_list {
   data_source_reference = {
     kind = "image"
     uuid = "${var.image}"
       }
       }

}
