terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.92.0"
    }
  }
}

resource "oci_core_instance" "instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = var.shape

  create_vnic_details {
    subnet_id = var.subnet_id
  }

  shape_config {
    memory_in_gbs = var.memory_in_gbs
    ocpus         = var.ocpus
  }

  source_details {
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs

    source_id   = var.source_id
    source_type = var.source_type
  }

  metadata = {
    user_data = var.user_data
  }
}
