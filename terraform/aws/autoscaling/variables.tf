variable wordpress_autoscaling_load_balancers {
  type        = list
  description = "Wordpress loadbalancers"
}

variable wordpress_autoscaling_subnets {
  type        = list
  description = "Autoscaling subnets"
}

variable wordpress_vpc_sg_ids {
  type        = list
  description = "Vpc security group id"
}

variable create_autoscaling {
  type        = bool
  description = "Flag to create a autoscaling"
}
