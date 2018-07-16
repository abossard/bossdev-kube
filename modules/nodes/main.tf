variable "token" {
  type="string"
}

variable "count" {
    default = 3
}

variable "hostname_format" {
    default = "knode%03d"
}

variable "location" {
    default = "scheisse"
}

variable "type" {
    default = "cx11"
}

variable "image" {
    default = "ubuntu-18.04"
}

variable "ssh_keys" {
  type = "list"
}

provider "hcloud" {
  token = "${var.token}"
}

variable "apt_packages" {
  type    = "list"
  default = []
}

resource "hcloud_ssh_key" "default" {
  name = "PC Key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}


resource "hcloud_server" "host" {
  name        = "${format(var.hostname_format, count.index + 1)}"
  image       = "${var.image}"
  server_type = "${var.type}"
  ssh_keys = ["${var.ssh_keys}"]

  count = "${var.count}"

  provisioner "remote-exec" {
      
    connection {
        type     = "ssh"
        user     = "root"
        private_key = "${file("~/.ssh/id_rsa")}"
    }
    
    inline = [
      "while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 1; done",
      "apt-get update && apt-get upgrade -y",
      "apt-get install -yq ufw ${join(" ", var.apt_packages)}",
    ]
  }
}


output "hostnames" {
  value = ["${hcloud_server.host.*.name}"]
}

output "public_ips" {
  value = ["${hcloud_server.host.*.ipv4_address}"]
}

output "private_ips" {
  value = ["${hcloud_server.host.*.ipv4_address}"]
}

output "private_network_interface" {
  value = "eth0"
}
