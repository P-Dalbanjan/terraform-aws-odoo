variable "instance_name" {
  description = "Odoo Deployment Using Terraform on AWS"
  type        = string
  default     = "odoo-terraform"
}

variable "instance_type" {
  description = "The EC2 instance's type."
  type        = list(string)
  default     = ["t3.micro", "t3.small", "t3.medium", "t3.large", "t3.xlarge", "t3.2xlarge"]
}
