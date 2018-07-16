variable "count" {
  default = 3
}

variable "domain" {
  default = "lookatmy.xyz"
}

variable "hcloud_token" {
  default = ""
}

variable "ssh_keys" {
  default = []
}

variable "cloudflare_email" {
  type = "string"
}

variable "cloudflare_token" {
  type = "string"
}