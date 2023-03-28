data "digitalocean_ssh_key" "aipc"{
  name = "id_rsa"
}

data "digitalocean_image" "nginx" {
  name = "nginx"
}

resource "digitalocean_droplet" "mynginx" {
  image  = data.digitalocean_image.nginx.id
  name   = "mynginx"
  region = "sgp1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.aipc.id]
}

