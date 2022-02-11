# Provides VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.base_name}_vpc"
  }
}

# Provides Subnet 1 (PUBLIC)
resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.sub1_cidr
  availability_zone = var.az1
  tags = {
    Name = "${var.base_name}_sub1_pub"
  }
}

# Provides Subnet 2 (PRIVATE)
resource "aws_subnet" "sub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.sub2_cidr
  availability_zone = var.az1
  tags = {
    Name = "${var.base_name}_sub2_pri"
  }
}

# Provides Elastic IP assigned to Internet Gateway
resource "aws_eip" "igw_eip" {
  vpc = true
  tags = {
    Name = "${var.base_name}_igw_eip"
  }
}

# Provides Internet Gateway for VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.base_name}_igw"
  }
}

# Provides Route Table for Public Subnet (Subnet 1)
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.base_name}_pub_rt"
  }
}

# Associates Subnet 1 with the Public Route Table
resource "aws_route_table_association" "pub_sub1_rta" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.pub_rt.id
}

# Provides Elastic IP for NAT Gateway
resource "aws_eip" "ngw_eip" {
  vpc = true
  tags = {
    Name = "${var.base_name}_ngw_eip"
  }
}

# Provides NAT Gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.sub1.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.base_name}_ngw"
  }
}

# Provides Route Table for Private Subnets (Subnet 3 and Subnet 4)
resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "${var.base_name}_pri_rt"
  }
}

# Associates Subnet 2 with the Private Route Table
resource "aws_route_table_association" "pri_sub2_rta" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.pri_rt.id
}

# Provides Security Group for SSH Access
resource "aws_security_group" "pub_ssh_sg" {
  name        = "ssh_access_public"
  description = "Allows SSH access from the public internet"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "SSH port 22 from public internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "public_ssh_access_sg"
  }
}

# Provides Security Group for ALB-to-ASG HTTP Communication
resource "aws_security_group" "pri_ssh_sg" {
  name        = "ssh_access_private"
  description = "Allows SSH access from the Control Node"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description     = "SSH port 22 from Subnet 1"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.pub_ssh_sg.id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "private_ssh_access_sg"
  }
}