resource "docker-image" "dov-bear"{
    name = "chukmunnlee/dov-bear:v4"
}

resource "docker-container" "dov-bear"{
    name = "my-dov-bear"
    image = docker_image.dov-bear.image_id
    ports{
        internal = 3000
        external = 3000
    }
    env = [
        "INSTANCE_NAME=my-dov-bear"
    ] 
}
