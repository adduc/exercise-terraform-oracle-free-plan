# cidr block

output "cidr_block" {
    value = oci_core_vcn.vcn.cidr_block
}

output "vcn_id" {
    value = oci_core_vcn.vcn.id
}