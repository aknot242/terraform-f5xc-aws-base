variable "project_prefix" {
  type        = string
  description = "projectPrefix name for tagging"
}

variable "resource_owner" {
  type        = string
  description = "Owner of the deployment for tagging purposes"
}

variable "trusted_ip" {
  type        = string
  description = "IP to allow external access"
}

variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "services_vpc_cidr_block" {
  type = string
}

variable "services_vpc" {
  description = "Services VPC"
  type        = map(any)
}
