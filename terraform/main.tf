# --- ./main.tf --- 

# Invokes VPC module
module "vpc" {
  source    = "./modules/vpc"
  base_name = var.base_name
}

# Invokes Secret Manager module
module "sm" {
  source    = "./modules/sm"
  base_name = var.base_name
}

# Invokes EC2 module
module "ec2" {
  source               = "./modules/ec2"
  base_name            = var.base_name
  sub1_id              = module.vpc.sub1
  sub2_id              = module.vpc.sub2
  pub_ssh_sg           = module.vpc.pub_ssh_sg
  pri_ssh_sg          = module.vpc.pri_ssh_sg
  key_name_control_node             = module.sm.key_name_control_node
  key_name_managed_node = module.sm.key_name_managed_node
}

output "ec2_ssh_pub_ip" {
  value = join(": ", ["Try to SSH to this IP. You'll have to get the key from Secrets Manager", module.ec2.ec2_ssh_pub_ip])
  description = "Output Public IP of Control Node at runtime completion"
}

output "ec2_ssh_pri_ip" {
  value = join(": ", ["SSH to this IP from the Control Node. You'll have to get the key from Secrets Manager", module.ec2.ec2_ssh_pri_ip])
  description = "Output Private IP of Managed Node at runtime completion"
}