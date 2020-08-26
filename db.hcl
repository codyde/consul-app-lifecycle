job "demodb" {
  datacenters = ["humblelabvm"]

  group "demodb" {
    network {
      mode = "bridge"
    }

    service {
      name = "db"
      port = "5432"

      connect {
        sidecar_service {}
      }
    }

    task "db" {
      driver = "docker"

      config {
        image = "codydearkland/demodb"
      }
    }
  }
}