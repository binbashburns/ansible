# Provides Ansible Control Node instance, which is managed via SSH
resource "aws_instance" "ec2_control_node" {
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
    yum list epel-release
    yum update -y
    yum install git -y
    yum install ansible -y
    yum install vim -y
    sudo useradd ansible
    sudo hostnamectl set-hostname --static ansible-control-node
    EOF
  tags = {
    Name = "${var.base_name}_ec2_control_node"
  }
}

# Provides Ansible Managed Node 1 instance, which is managed via SSH
resource "aws_instance" "ec2_managed_node1" {
  ami                         = var.ami
  subnet_id                   = var.sub2_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.pri_ssh_sg]
  associate_public_ip_address = false
  key_name                    = var.key_name_managed_node1
  root_block_device {
    volume_size = 20
  }
  user_data = <<-EOF
    #!/bin/bash
    yum install vim -y
    sudo useradd ansible
    sudo hostnamectl set-hostname --static ansible-managed-node-1
    EOF
  tags = {
    Name = "${var.base_name}_ec2_managed_node1"
  }
}

# Provides Ansible Managed Node 2 instance, which is managed via SSH
resource "aws_instance" "ec2_managed_node2" {
  ami                         = var.ami
  subnet_id                   = var.sub2_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.pri_ssh_sg]
  associate_public_ip_address = false
  key_name                    = var.key_name_managed_node2
  root_block_device {
    volume_size = 20
  }
  user_data = <<-EOF
    #!/bin/bash
    yum install vim -y
    sudo useradd ansible
    sudo hostnamectl set-hostname --static ansible-managed-node-2
    EOF
  tags = {
    Name = "${var.base_name}_ec2_managed_node2"
  }
}