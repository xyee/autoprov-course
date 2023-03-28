terraform{
    required_providers{
        docker = {
            source = "kreuzwerker/docker"
            version = "3.0.2"
        }
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "2.26.0"
        }
        local = {
            source = "hashicorp/local"
            version = "2.4.0"
        }
    }
}

provider "docker"{
    host = "unix:///var/run/docker.sock"
}

provider "digitalocean"{
    token = "dop_v1_af16d7d2ba03dc8a289b4bb30dd025de2ebcaf4c86a1b61cc8c71da36029798e"
}

provider "local"{

}