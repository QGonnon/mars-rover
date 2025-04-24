terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "web" {
    name  = "mars-rover-web"
    image =  docker_image.nginx.name
    ports {
        internal = 80
        external = 8080
    }
}

resource "docker_container" "db" {
  name = "mars-db"
  image = "mysql:8.0"
  env = [ 
    "MYSQL_ROOT_PASSWORD=rov3r",
   ]
   networks_advanced {
    name = docker_network.mars_net.name
   }
}

resource "docker_network" "mars_net"{
  name = "mars-network"
}
