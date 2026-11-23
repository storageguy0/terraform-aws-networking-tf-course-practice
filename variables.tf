variable "vpc_config" {
  description = "Contains The VPC configuration. More specifically, the CIDR block for the VPC and the name of the VPC."
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The cidr_blog config option must contain a valid CIDR block."
  }
}

variable "subnet_config" {
  description = <<EOT
  Accepts a map of subnet configurations. Each subnet configuration must contain:
  - cidr_block: The CIDR block for the subnet.
  - public: (Optional) Whether the subnet is public or not. Defaults to false.
  - az: The availability zone where to deploy the subnet.
  EOT

  type = map(object({
    cidr_block = string
    public     = optional(bool, false)
    az         = string
  }))

  validation {
    condition = alltrue([
      for config in values(var.subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "The cidr_block config option must contain a valid CIDR block."
  }
}