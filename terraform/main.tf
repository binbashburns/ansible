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
  source                 = "./modules/ec2"
  base_name              = var.base_name
  sub1_id                = module.vpc.sub1
  sub2_id                = module.vpc.sub2
  pub_ssh_sg             = module.vpc.pub_ssh_sg
  pri_ssh_sg             = module.vpc.pri_ssh_sg
  key_name_control_node  = module.sm.key_name_control_node
  key_name_managed_node1 = module.sm.key_name_managed_node1
  key_name_managed_node2 = module.sm.key_name_managed_node2

}

output "ec2_ssh_pub_ip" {
  value       = join(": ", ["Try to SSH to this IP. You'll have to get the key from Secrets Manager", module.ec2.ec2_ssh_pub_ip])
  description = "Output Public IP of Control Node at runtime completion"
}

output "ec2_ssh_pri_ip1" {
  value       = join(": ", ["SSH to Managed Node 1 from the Control Node. You'll have to get the key from Secrets Manager", module.ec2.ec2_ssh_pri_ip1])
  description = "Output Private IP of Managed Node 1 at runtime completion"
}

output "ec2_ssh_pri_ip2" {
  value       = join(": ", ["SSH to Managed Node 2 from the Control Node. You'll have to get the key from Secrets Manager", module.ec2.ec2_ssh_pri_ip2])
  description = "Output Private IP of Managed Node 2 at runtime completion"
}