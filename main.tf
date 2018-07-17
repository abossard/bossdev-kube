
module "provider" {
    source = "./modules/nodes"
    token           = "${var.hcloud_token}"
    ssh_keys        = "${var.ssh_keys}"
    count = "${var.count}"
}

module "dns" {
    email = "${var.cloudflare_email}"
    token = "${var.cloudflare_token}"
    source = "./modules/dns"
    count = "${var.count}"
    domain = "${var.domain}"
    public_ips = "${module.provider.public_ips}"
    hostnames = "${module.provider.hostnames}"
}

module "swap" {
  source = "./modules/swap"

  count       = "${var.count}"
  connections = "${module.provider.public_ips}"
}


module "firewall" {
  source = "./modules/ufw"

  count                = "${var.count}"
  connections          = "${module.provider.public_ips}"
  private_interface    = "${module.provider.private_network_interface}"
  vpn_interface        = "${module.wireguard.vpn_interface}"
  vpn_port             = "${module.wireguard.vpn_port}"
  kubernetes_interface = "${module.kubernetes.overlay_interface}"
}

module "wireguard" {
  source = "./modules/wireguard"

  count        = "${var.count}"
  connections  = "${module.provider.public_ips}"
  private_ips  = "${module.provider.private_ips}"
  hostnames    = "${module.provider.hostnames}"
  overlay_cidr = "${module.kubernetes.overlay_cidr}"
}

module "etcd" {
  source = "./modules/etcd"

  count       = "${var.count}"
  connections = "${module.provider.public_ips}"
  hostnames   = "${module.provider.hostnames}"
  vpn_unit    = "${module.wireguard.vpn_unit}"
  vpn_ips     = "${module.wireguard.vpn_ips}"
}

module "kubernetes" {
  source = "./modules/kubernetes"

  count          = "${var.count}"
  connections    = "${module.provider.public_ips}"
  cluster_name   = "${var.domain}"
  vpn_interface  = "${module.wireguard.vpn_interface}"
  vpn_ips        = "${module.wireguard.vpn_ips}"
  etcd_endpoints = "${module.etcd.endpoints}"
}
