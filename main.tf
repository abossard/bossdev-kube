
variable "token" {
  default = ""
}

variable "ssh_keys" {
  default = []
}

module "provider" {
    source = "./modules/nodes"
    token           = "${var.token}"
    ssh_keys        = "${var.ssh_keys}"
}