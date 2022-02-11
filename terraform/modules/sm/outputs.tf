output "key_name_control_node" {
  description = "Name of the Control Node keypair"
  value       = aws_key_pair.keypair_control_node.id
}

output "key_name_managed_node" {
  description = "Name of the Managed Node keypair"
  value       = aws_key_pair.keypair_managed_node.id
}