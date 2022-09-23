variable instance_ips {
  type        = list
  description = "All instances ips"
}

variable ansible_path {
  type        = string
  default     = "hosts"
  description = " Ansible file path"
}

variable wordpress_db_host {
  type        = string
}

variable wordpress_db_pass {
  type        = string
}

variable wordpress_host {
  type        = string
}

variable wordpress_memcached {
  type        = string
}

variable wordpress_instance_id {
  type        = string
}
