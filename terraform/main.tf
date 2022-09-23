terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.9"
}

provider "aws" {
}

module network {
  source = "./aws/network"

  vpc_cidr_block                 = "10.30.0.0/16"

  public_az_a_subnet_cidr_block  = "10.30.0.0/24"
  public_az_b_subnet_cidr_block  = "10.30.1.0/24"
  private_az_a_subnet_cidr_block = "10.30.2.0/24"
  private_az_b_subnet_cidr_block = "10.30.3.0/24"
}

module instance {
  source = "./aws/ec2"

  instance_ami           = var.instance_ami
  instance_type          = var.instance_type
  instance_subnet_id     = module.network.public_az_a_subnet_id
  vpc_id                 = module.network.vpc_id
  my_ip                  = "${chomp(data.http.my_ip.body)}/32"
}

module rds {
  source = "./aws/rds"

  vpc_id                   = module.network.vpc_id
  wordpress_db_subnet_a_id   = module.network.private_az_a_subnet_id
  wordpress_db_subnet_b_id   = module.network.private_az_b_subnet_id
  wordpress_instance_sg_id = module.instance.wordpress_instance_sg_id

  my_ip                    = "${chomp(data.http.my_ip.body)}/32"

}

module elasticache {
  source = "./aws/elasticache"

  vpc_id                          = module.network.vpc_id
  wordpress_memcached_subnet_a_id = module.network.private_az_a_subnet_id
  wordpress_memcached_subnet_b_id = module.network.private_az_b_subnet_id
  wordpress_instance_sg_id        = module.instance.wordpress_instance_sg_id

  my_ip                    = "${chomp(data.http.my_ip.body)}/32"

}

module loadbalancer {
  source = "./aws/loadbalancer"

  vpc_id                             = module.network.vpc_id
  wordpress_loadbalancer_subnets_ids = [module.network.public_az_a_subnet_id, module.network.public_az_b_subnet_id]
  wordpress_instances_ids            = [module.instance.wordpress_instance_id]
}

module ansible_vars {
  source = "./tools/ansible"

  instance_ips = [module.instance.wordpress_instance_ip]
  wordpress_db_host = module.rds.wordpress_db_host
  wordpress_db_pass = module.rds.wordpress_db_password
  wordpress_host = module.loadbalancer.wordpress_loadbalancer_endpoint
  wordpress_memcached = module.elasticache.wordpress_memcached_endpoint
  wordpress_instance_id = module.instance.wordpress_instance_id
}

module autoscaling {
  source = "./aws/autoscaling"

  create_autoscaling                   = var.create_autoscaling
  wordpress_autoscaling_load_balancers = [module.loadbalancer.wordpress_loadbalancer_name]
  wordpress_autoscaling_subnets        = [module.network.public_az_a_subnet_id, module.network.public_az_b_subnet_id]
  wordpress_vpc_sg_ids                 = [module.instance.wordpress_instance_sg_id]
}


output loadbalancer_endpoint {
  value       =  module.loadbalancer.wordpress_loadbalancer_endpoint
}


