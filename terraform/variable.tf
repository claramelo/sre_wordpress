data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

variable instance_type {
  type        = string
  default     = "t2.micro"
  description = "Instance Type"
}

variable instance_ami {
  type        = string
  default     = "ami-08d4ac5b634553e16"
  description = "Ubuntu 20.04 ami"
}

variable create_autoscaling {
  type        =  bool
  default     = false
  description = "Enable autoscaling"
}
