variable do_token {
    type = string
    sensitive = true
}

# variable image_name {
#     type = string 
#     default = "chukmunnlee/dov-bear:v4"
# }

variable instance_count {
    type = number
    default = 3
}

variable docker_host {
    type = string
    default = "167.172.64.36"
}