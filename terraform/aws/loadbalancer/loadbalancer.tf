resource "aws_elb" "sre_wordpress_loadbalancer" {
  name               = "wordpress-loadbalance"

  security_groups    = [aws_security_group.sre_wordpress_loadbalancer_sg.id]
  subnets            = var.wordpress_loadbalancer_subnets_ids

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    target              = "TCP:80"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  instances           = var.wordpress_instances_ids

  tags = {
    Name = "Wordpress loadbalancer"
  }
}

output wordpress_loadbalancer_endpoint {
  value = aws_elb.sre_wordpress_loadbalancer.dns_name
}

output wordpress_loadbalancer_name {
  value = aws_elb.sre_wordpress_loadbalancer.name
}