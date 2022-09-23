
variable wordpress_instance_sg_id {
  type        = string
  description = "Wordpress instance security group"
}

variable vpc_id {
  type        = string
  description = "description"
}

variable my_ip {
  description = "description"
}

resource "aws_security_group" "sre_wordpress_db_sg" {
  vpc_id = "${var.vpc_id}"

  ingress {
    description      = "TCP"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  ingress {
    description      = "TCP"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [var.wordpress_instance_sg_id]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Wordpress database security group"
  }

}