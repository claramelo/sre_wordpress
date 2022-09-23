data "aws_ami" "wordpress_ami" {
  count = var.create_autoscaling ? 1 : 0

  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["Wordpress*"]
  }
}

resource "aws_launch_template" "wordpress_launch_template" {
  count = var.create_autoscaling ? 1 : 0

  name_prefix   = "wordpress_launch_template"
  image_id      = element([for ami in data.aws_ami.wordpress_ami : ami.id], 0)
  instance_type = "t2.micro"
  vpc_security_group_ids = var.wordpress_vpc_sg_ids

}

resource "aws_autoscaling_group" "wordpress_autoscaling_group" {
  count = var.create_autoscaling ? 1 : 0

  load_balancers      = var.wordpress_autoscaling_load_balancers
  vpc_zone_identifier = var.wordpress_autoscaling_subnets
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2

  launch_template {
    id      = element([for launch_template in aws_launch_template.wordpress_launch_template : launch_template.id], 0)
    version = "$Latest"
  }
}