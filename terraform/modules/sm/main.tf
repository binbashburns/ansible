### --- Control Node Key --- ###

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Provides an EC2 key pair resource for Control Node
resource "aws_key_pair" "keypair_control_node" {
  key_name   = "${var.base_name}_control_node_key"
  public_key = tls_private_key.key1.public_key_openssh
}

# Provides a resource to manage AWS Secrets Manager secret metadata
resource "aws_secretsmanager_secret" "secret_key1" {
  name_prefix = var.base_name
  description = var.description
  tags = {
    Name = "${var.base_name}-control-node-key"
  }
}

# Provides a resource to manage AWS Secrets Manager secret version including its secret value
resource "aws_secretsmanager_secret_version" "secret_key_value1" {
  secret_id     = aws_secretsmanager_secret.secret_key1.id
  secret_string = tls_private_key.key1.private_key_pem
}

### --- Managed Node 1 Key --- ###

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Provides an EC2 key pair resource for 
resource "aws_key_pair" "keypair_managed_node1" {
  key_name   = "${var.base_name}_managed_node1_key"
  public_key = tls_private_key.key2.public_key_openssh
}

# Provides a resource to manage AWS Secrets Manager secret metadata
resource "aws_secretsmanager_secret" "secret_key2" {
  name_prefix = var.base_name
  description = var.description
  tags = {
    Name = "${var.base_name}-managed-node1-key"
  }
}

# Provides a resource to manage AWS Secrets Manager secret version including its secret value
resource "aws_secretsmanager_secret_version" "secret_key_value2" {
  secret_id     = aws_secretsmanager_secret.secret_key2.id
  secret_string = tls_private_key.key2.private_key_pem
}

### --- Managed Node 2 Key --- ###

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key3" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Provides an EC2 key pair resource for 
resource "aws_key_pair" "keypair_managed_node2" {
  key_name   = "${var.base_name}_managed_node2_key"
  public_key = tls_private_key.key3.public_key_openssh
}

# Provides a resource to manage AWS Secrets Manager secret metadata
resource "aws_secretsmanager_secret" "secret_key3" {
  name_prefix = var.base_name
  description = var.description
  tags = {
    Name = "${var.base_name}-managed-node2-key"
  }
}

# Provides a resource to manage AWS Secrets Manager secret version including its secret value
resource "aws_secretsmanager_secret_version" "secret_key_value3" {
  secret_id     = aws_secretsmanager_secret.secret_key3.id
  secret_string = tls_private_key.key3.private_key_pem
}