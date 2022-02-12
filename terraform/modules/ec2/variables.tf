variable "base_name" {
  type        = string
  description = "The base name for the EC2 instance"
}

variable "ami" {
  type        = string
  default     = "ami-0affd4508a5d2481b"
  description = "The AMI for the EC2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The Instance Type for the EC2 instance"
}

variable "sub1_id" {
  type        = string
  description = "The ID of subnet 1, from the VPC Module"

}

variable "sub2_id" {
  type        = string
  description = "The ID of subnet 2, from the VPC Module"

}

variable "pub_ssh_sg" {
  type        = string
  description = "Imports the Public SSH Security Group"
}

variable "pri_ssh_sg" {
  type        = string
  description = "Imports the Private SSH Security Group"
}

variable "key_name_control_node" {
  description = "Imports name of SecretsManager managed Key for control node"
}

variable "key_name_managed_node1" {
  description = "Imports name of SecretsManager managed Key for managed node1"
}

variable "key_name_managed_node2" {
  description = "Imports name of SecretsManager managed Key for managed node2"
}