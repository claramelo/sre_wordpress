variable wordpress_db_subnet_a_id {
  type        = string
  description = "Wordpress db subnet id"
}

variable wordpress_db_subnet_b_id {
  type        = string
  description = "Wordpress db subnet id"
}

resource "random_password" "sre_wordpress_db_password" {
  length           = 16
  special          = true
  override_special = "!*_-"
}

resource "aws_db_subnet_group" "sre_wordpress_db_subnet_group" {
  name       = "wordpress_db_subnet_group"
  subnet_ids = [var.wordpress_db_subnet_a_id, var.wordpress_db_subnet_b_id ]

  tags = {
    Name = "  Wordpress DB subnet group"
  }
}

resource "aws_db_instance" "sre_wordpress_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "wordpress"
  username               = "wpuser"
  password               = random_password.sre_wordpress_db_password.result
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.sre_wordpress_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.sre_wordpress_db_subnet_group.name
  multi_az               = true

  tags = {
    Name = "Wordpress database"
  }
}

output wordpress_db_host {
  value       = aws_db_instance.sre_wordpress_db.address
}

output wordpress_db_password {
  value       = aws_db_instance.sre_wordpress_db.password
}
