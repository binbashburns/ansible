variable "base_name" {
  type        = string
  description = "The base name for the VPC"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.1.0.0/16"
  description = "The CIDR block for the VPC"
}

variable "sub1_cidr" {
  type        = string
  default     = "10.1.1.0/24"
  description = "The CIDR block for Subnet 1"
}

variable "sub2_cidr" {
  type        = string
  default     = "10.1.2.0/24"
  description = "The CIDR block for Subnet 2"
}

variable "az1" {
  type        = string
  default     = "us-east-1a"
  description = "Availability Zone 1"
}