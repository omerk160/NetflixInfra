variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  description = "EC2 Ubuntu AMI"
  type        = string
}
variable "ssh_public_key" {
  description = "SSH public key for EC2 instances"
  type        = string
}
