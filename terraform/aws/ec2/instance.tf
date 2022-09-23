resource "aws_instance" "sre_wordpress_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sre_wordpress_sg.id]
  subnet_id     = var.instance_subnet_id
  key_name      = aws_key_pair.key_pair.key_name
  
  tags = {
    Name = "Wordpress Instance"
  }
}

output wordpress_instance_id {
  value = aws_instance.sre_wordpress_instance.id
}

output wordpress_instance_ip {
  value = aws_instance.sre_wordpress_instance.public_ip
}