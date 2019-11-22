resource "digitalocean_droplet" "do-droplet" {
  image  = "centos-7-x64"
  name   = "cicd-tools"
  region = "sfo2"
  size   = "s-8vcpu-16gb"
}