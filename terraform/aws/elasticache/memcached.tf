resource "aws_elasticache_subnet_group" "sre_wordpress_memcached_subnet_group" {
  name       = "wordpress-memcached-subnet-group"
  subnet_ids = [var.wordpress_memcached_subnet_a_id, var.wordpress_memcached_subnet_b_id ]

  tags = {
    Name = "  Wordpress memcached subnet group"
  }
}

resource "aws_elasticache_cluster" "sre_wordpress_memcached" {
  cluster_id           = "sre-wordpress-memcached-cluster"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  parameter_group_name           = "default.memcached1.6"
  port                           = 11211
  preferred_availability_zones   = ["us-east-1a","us-east-1b"]
  security_group_ids   = [aws_security_group.sre_wordpress_elasticache_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.sre_wordpress_memcached_subnet_group.name

  tags = {
    Name = "Wordpress memcached"
  }
}

output wordpress_memcached_endpoint {
  value       = aws_elasticache_cluster.sre_wordpress_memcached.cluster_address
}
