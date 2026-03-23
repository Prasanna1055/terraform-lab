terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

# Pull nginx image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Create containers dynamically
resource "docker_container" "nginx" {
  for_each = {
    for c in var.container_config : c.name => c
  }

  name  = each.value.name
  image = docker_image.nginx.name

  ports {
    internal = 80
    external = each.value.port
  }
}
