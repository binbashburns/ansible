output "key_name_control_node" {
  description = "Name of the Control Node keypair"
  value       = aws_key_pair.keypair_control_node.id
}

output "key_name_managed_node1" {
  description = "Name of the Managed Node 1 keypair"
  value       = aws_key_pair.keypair_managed_node1.id
}

output "key_name_managed_node2" {
  description = "Name of the Managed Node 2 keypair"
  value       = aws_key_pair.keypair_managed_node2.id
}