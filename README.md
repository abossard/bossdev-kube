# Boss Kube
the kubernetes config of bossdev.org

## Getting started
1. Create a file `config.tfvars`
2. Put something like this in it:
   
    token = "<hetzner cloud token>"
    ssh_keys = ["<public key string>"]
    domain = "<the domain name>"
    cloudflare_email = "<cloudflare email>"
    cloudflare_token = "<cloudflare token>"
    apt_packages = [""]
