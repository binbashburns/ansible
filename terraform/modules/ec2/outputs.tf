output "ec2_ssh_pub_ip" {
  value       = aws_instance.ec2_control_node.public_ip
  description = "Output Public IP of Control Node to be output by main.tf at runtime completion"
}

output "ec2_ssh_pri_ip1" {
  value       = aws_instance.ec2_managed_node1.private_ip
  description = "Output Private IP of Managed Node 1 to be output by main.tf at runtime completion"
}

output "ec2_ssh_pri_ip2" {
  value       = aws_instance.ec2_managed_node2.private_ip
  description = "Output Private IP of Managed Node 2 to be output by main.tf at runtime completion"
}