output "ec2_ssh_pub_ip" {
  value = aws_instance.rhel_ec2_control_node.public_ip
  description = "Output Public IP of Control Node to be output by main.tf at runtime completion"
}

output "ec2_ssh_pri_ip" {
  value = aws_instance.rhel_ec2_managed_node.private_ip
  description = "Output Private IP of Managed Node to be output by main.tf at runtime completion"
}