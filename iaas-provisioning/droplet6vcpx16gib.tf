resource "digitalocean_droplet" "droplet6vcpx16gib" {
  name   = "cicd-tools"
  image  = "centos-7-x64"  
  region = "sfo2"
  size   = "s-6vcpu-16gb"
}