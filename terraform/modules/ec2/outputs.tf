output "ec2_ssh_pub_ip" {
  value = aws_instance.rhel_ec2_control_node.public_ip
}