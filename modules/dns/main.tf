variable "count" {}

variable "email" {}

variable "token" {}

variable "domain" {}

variable "hostnames" {
    type = "list"
}

variable "public_ips" {
    type = "list"
}

provider "cloudflare" {
    email = "${var.email}"
    token = "${var.token}"
}

resource "cloudflare_record" "hosts" {
    
}