##
# @see https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm#resources
##

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.92.0"
    }
  }
}

provider "oci" {
  # EnvVar: TF_VAR_tenancy_ocid
  # EnvVar: TF_VAR_compartment_id
  # EnvVar: TF_VAR_user_ocid
  # EnvVar: TF_VAR_fingerprint
  # EnvVar: TF_VAR_private_key_path
  # EnvVar: TF_VAR_region
  # EnvVar: TF_VAR_availability_domain
}

module "vcn" {
  source         = "../../modules/oracle-vcn"
  compartment_id = var.compartment_id
  cidr_block     = "10.0.0.0/16"
}

resource "oci_core_subnet" "subnet" {
  cidr_block     = cidrsubnet(module.vcn.cidr_block, 8, 0)
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
}

data "oci_core_images" "ubuntu_2204_arm" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04 Minimal aarch64"
  shape                    = "VM.Standard.A1.Flex"
}

module "app" {
  count                   = 1
  source                  = "../../modules/oracle-instance"
  compartment_id          = var.compartment_id
  availability_domain     = var.availability_domain
  memory_in_gbs           = 24
  ocpus                   = 4
  source_id               = data.oci_core_images.ubuntu_2204_arm.images[0].id
  boot_volume_size_in_gbs = 200
  subnet_id               = oci_core_subnet.subnet.id
  shape                   = "VM.Standard.A1.Flex"

  user_data = base64encode(templatefile("${path.module}/cloud-init.default.yaml", {
    hostname    = "app${count.index + 1}"
    user        = var.user
    user_github = var.user_github
    user_id     = var.user_id
  }))
}
