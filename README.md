# Kubernetes Cluster with Terraform
Based on https://github.com/hobby-kube/guide

# Getting Started
## 1. Preparing the Config
1. create yourself a Hetzer Clound API Key (hcloud_token)
2. add your ssh public key to hetzner and remember the key name you give (ssh_keys)
3. get yourself an API Key from Cloudflare to manage the dns (cloudflare_token)
4. Have a domain on cloudflare (domain)
5. Create a file `config.tfvars` or `.tfvars` or however you want to name it
6. Put something like this in it:

```
hcloud_token = "<create a new hcloud token>"
ssh_keys = ["ssh key name from hetzner"]
cloudflare_email = "mymail@mydomain.com"
cloudflare_token = "<funky cloudflare key>"
domain = "superdomain.com"
host_count = 3
```


## 2. Required tools
Some of the commands are executed locally to generate keys and configs for the nodes. That's why you need these tools installed:
- `kubectl`
- `wg` (wireguard cli)
- `jq`

It doesn't work without it. So forget to run this on Windows.

## 3. Preparing Terraform
```
terraform init
terraform plan -var-file=.tfvars
terraform apply -var-file=.tfvars
```

## 4. Wait

## 5. Enjoy `kubectl get nodes`

