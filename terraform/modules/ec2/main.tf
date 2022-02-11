# Provides Ansible Control Node RHEL instance, which is managed via SSH
resource "aws_instance" "rhel_ec2_control_node" {
  ami                         = var.ami
  subnet_id                   = var.sub1_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.pub_ssh_sg]
  associate_public_ip_address = true
  key_name                    = var.key_name_control_node
  root_block_device {
    volume_size = 20
  }
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install ansible -y
    yum install vim -y
    git clone https://github.com/binbashburns/ansible.git
    EOF
  tags = {
    Name = "${var.base_name}_rhel_ec2_control_node"
  }
}

# Provides Ansible Managed Node RHEL instance, which is managed via SSH
resource "aws_instance" "rhel_ec2_managed_node" {
  ami                         = var.ami
  subnet_id                   = var.sub2_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.pri_ssh_sg]
  associate_public_ip_address = false
  key_name                    = var.key_name_managed_node
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "${var.base_name}_rhel_ec2_managed_node"
  }
}