resource "docker_network" "bgg_net" {
  name = "bgg_net"
}

resource "docker_volume" "bgg_volume" {
  name = "bgg_volume"
}
# Find the latest Ubuntu precise image.
resource "docker_image" "bgg_database" {
  name = "chukmunnlee/bgg-database:v3.1"
}
# Start a container
resource "docker_container" "bgg_database" {
  name  = "bgg_database"
  image = docker_image.bgg_database.image_id
  volumes {
    container_path = "/var/lib/mysql"
    volume_name = docker_volume.bgg_volume.name
  }
  ports {
    internal = 3306
    external = 3306
  }
  networks_advanced{
    name = docker_network.bgg_net.name
  }
}

resource "docker_image" "bgg_backend" {
  name = "chukmunnlee/bgg-backend:v3"
}

resource "docker_container" "bgg_backend" {
    count = var.instance_count
    name = "bgg_bbackend_${count.index}"
    image = docker_image.bgg_backend.image_id
    ports {
        internal = 3000
        external = 3000 + count.index
    }
    networks_advanced{
      name = docker_network.bgg_net.name
    }
    env = [
        "BGG_DB_USER=root",
        "BGG_DB_PASSWORD=changeit",
        "BGG_DB_HOST=${docker_container.bgg_database.name}"
    ]
}

resource "local_file" "nginx-conf"{
  filename = "nginx.conf"
  content = templatefile("sample.nginx.conf.tftpl", {
    docker_host = var.docker_host,
    ports = docker_container.bgg_backend[*].ports[0].external
  })
}

data "digitalocean_ssh_key" "aipc"{
  name = "id_rsa"
}

# Create a new Web Droplet in the sg region
resource "digitalocean_droplet" "nginx-droplet" {
  image  = "ubuntu-20-04-x64"
  name   = "nginx-droplet"
  region = "sgp1"
  size   = "s-1vcpu-512mb-10gb"
  ssh_keys = [data.digitalocean_ssh_key.aipc.id]
  
}
