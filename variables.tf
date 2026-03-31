variable "instance_name" {
  description = "Odoo Deployment Using Terraform on AWS"
  type        = string
  default     = "odoo-terraform"
}

variable "instance_type" {
  description = "The EC2 instance's type."
  type        = string
  default     = "t3.small"

  validation {
    condition     = contains(["t3.small", "t3.medium", "t3.large", "t3.xlarge", "t3.2xlarge"], var.instance_type)
    error_message = "Instance type must be t3.small or larger"
  }
}
