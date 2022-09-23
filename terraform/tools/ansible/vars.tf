resource "local_file" "ansible_hosts" {
    content  = templatefile("${path.module}/hosts.tftpl",{"instance_ips":var.instance_ips})
    filename = "../ansible/hosts"
}

resource "local_file" "ansible_vars" {
    content  = templatefile("${path.module}/variables.tftpl",{"wordpress_instance_id": var.wordpress_instance_id,"wordpress_db_host": var.wordpress_db_host, "wordpress_db_pass": var.wordpress_db_pass, "wordpress_memcached": var.wordpress_memcached, "wordpress_host": var.wordpress_host})
    filename = "../ansible/vars/variables.yml"
}