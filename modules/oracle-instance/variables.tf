variable "compartment_id" {
  type = string
}

variable "availability_domain" {
  type = string
}

variable "memory_in_gbs" {
  type = number
}

variable "ocpus" {
  type = number
}

variable "source_id" {
  type = string
}

variable "source_type" {
  type    = string
  default = "image"
}

variable "user_data" {
  type = string
}

variable "boot_volume_size_in_gbs" {
  type = number
}

variable "subnet_id" {
  type = string
}

variable "shape" {
  type = string
}