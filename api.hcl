job "api" {
  datacenters = ["humblelabvm"]

  group "api" {
    network {
      mode = "bridge"
      port "api" {}
    }

    service {
      name = "api"
      port = "5000"

      meta {
                version = "v1"
              }
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "db"
              local_bind_port = 5432
            }
          }
        }
      }

    }

    update {
      max_parallel     = 1
      min_healthy_time = "30s"
      healthy_deadline = "9m"
      canary = 1
    }

    count = 3

    task "api" {
      driver = "docker"

    env {
            PORT    = "${NOMAD_PORT_api}"
            NODE_IP = "${NOMAD_IP_api}"
            POSTGRES_HOST="localhost"
            POSTGRES_USER="postgres"
            POSTGRES_PASSWORD="postgres_password"
            POSTGRES_PORT="5432"
            POSTGRES_DATABASE="posts"
      }

    config {
        image = "codydearkland/apiv2:beta2"
      }
    }
  }
}
