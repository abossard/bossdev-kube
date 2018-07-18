variable "count" {}

variable "connections" {
  type = "list"
}

variable "hostnames" {
  type = "list"
}

variable "vpn_unit" {
  type = "string"
}

variable "vpn_ips" {
  type = "list"
}

variable "version" {
  default = "v3.3.8"
}

resource "null_resource" "etcd" {
  count = "${var.count}"

  triggers = {
    template = "${join("", data.template_file.etcd-service.*.rendered)}"
  }

  connection {
    host  = "${element(var.connections, count.index)}"
    user  = "root"
    agent = true
  }

  provisioner "remote-exec" {
    connection {
        type     = "ssh"
        user     = "root"
        private_key = "${file("~/.ssh/id_rsa")}"
    }
    
    inline = <<EOF
${data.template_file.install.rendered}
EOF
  }

  provisioner "file" {
    connection {
        type     = "ssh"
        user     = "root"
        private_key = "${file("~/.ssh/id_rsa")}"
    }
    
    content     = "${element(data.template_file.etcd-service.*.rendered, count.index)}"
    destination = "/etc/systemd/system/etcd.service"
  }

  provisioner "remote-exec" {
    connection {
        type     = "ssh"
        user     = "root"
        private_key = "${file("~/.ssh/id_rsa")}"
    }
    
    inline = [
      "systemctl is-enabled etcd.service || systemctl enable etcd.service",
      "systemctl daemon-reload",
      "systemctl restart etcd.service",
    ]
  }
}

data "template_file" "etcd-service" {
  count    = "${var.count}"
  template = "${file("${path.module}/templates/etcd.service")}"

  vars {
    hostname              = "${element(var.hostnames, count.index)}"
    intial_cluster        = "${join(",", formatlist("%s=http://%s:2380", var.hostnames, var.vpn_ips))}"
    listen_client_urls    = "http://${element(var.vpn_ips, count.index)}:2379"
    advertise_client_urls = "http://${element(var.vpn_ips, count.index)}:2379"
    listen_peer_urls      = "http://${element(var.vpn_ips, count.index)}:2380"
    vpn_unit              = "${var.vpn_unit}"
  }
}

data "template_file" "install" {
  template = "${file("${path.module}/scripts/install.sh")}"

  vars {
    version = "${var.version}"
  }
}

data "null_data_source" "endpoints" {
  depends_on = ["null_resource.etcd"]

  inputs = {
    list = "${join(",", formatlist("http://%s:2379", var.vpn_ips))}"
  }
}

output "endpoints" {
  value = ["${split(",", data.null_data_source.endpoints.outputs["list"])}"]
}