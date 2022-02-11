output "sub1" {
  value = aws_subnet.sub1.id
}

output "sub2" {
  value = aws_subnet.sub2.id
}

output "pub_ssh_sg" {
  value = aws_security_group.pub_ssh_sg.id
}

output "pri_ssh_sg" {
  value = aws_security_group.pri_ssh_sg.id
}