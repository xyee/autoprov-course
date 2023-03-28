data "digitalocean_ssh_key" "day2key"{
  name = "day2key"
}

# Create a new Web Droplet in the sg region
resource "digitalocean_droplet" "day02-droplet" {
  image  = "ubuntu-20-04-x64"
  name   = "day02-droplet"
  region = "sgp1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.day2key.id]
  connection{
    type = "ssh"
    user = "root"
    private_key = file(var.ssh_private_key)
    host = self.ipv4_address
  }
}

resource "local_file" "inventory" {
  filename = "inventory.yaml"
  content = templatefile("./inventory.yaml.tftpl",
    {
        user = "root",
        ssh_private_key = var.ssh_private_key,
        codeserver_ip = digitalocean_droplet.day02-droplet.ipv4_address,
        codeserver_domain = "code-server-${digitalocean_droplet.day02-droplet.ipv4_address}.nip.io",
        codeserver_password = "changeit"
    })
  file_permission = "0444"
}


 

