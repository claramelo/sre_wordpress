variable wordpress_memcached_subnet_a_id {
  type        = string
  description = "Wordpress memcached subnet id"
}

variable wordpress_memcached_subnet_b_id {
  type        = string
  description = "Wordpress memcached subnet id"
}

variable wordpress_instance_sg_id {
  type        = string
  description = "Wordpress instance security group"
}

variable vpc_id {
  type        = string
  description = "Wordpress vpc id"
}

variable my_ip {
  description = "My ip"
}