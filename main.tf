variable "region" {
  type    = string
  default = "eu-west-1"
}

provider "aws" {
  region     = var.region
  access_key = "my-access-key"
  secret_key = "my-secret"
}

terraform {}

# Create security group
module "network" {
  source = "./modules/network"
}

# Create instance 
module "ec2" {
  source = "./modules/ec2"

  instance_sg_name = module.network.instance_sg_name
  instance_sg      = module.network.instance_sg
  public_lb_subnet = module.network.public_lb_subnet
}

# Create load balancer 
module "alb" {
  source = "./modules/alb"

  vpc_id                     = module.network.vpc_id
  alb_sg_id                  = module.network.alb_sg_id
  public_lb_subnet           = module.network.public_lb_subnet
  public_lb_secondary_subnet = module.network.public_lb_secondary_subnet
  instance_sg                = module.network.instance_sg
  instance_id                = module.ec2.instance_id
}

output "instance_public_ip" {
  value = module.ec2.instance_public_ip
}
output "security_group" {
  value = module.network.instance_sg
}
output "lb_dns" {
  value = module.alb.alb_dns
}
