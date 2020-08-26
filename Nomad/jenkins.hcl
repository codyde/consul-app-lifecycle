job "jenkins" {
  datacenters = ["syno"]

  group "jenkins" {
    count = 1

    task "jenkins" {
      driver = "docker"

      config {
        image = "jenkins/jenkins:latest"

        port_map {
          http = 8080
          jenkins = 50000
        }

        volumes = [
          "/volume2/nas/jenkins:/var/jenkins_home",
        ]
      }

      resources {
        memory = 4096
        network {
          port "http" {
            static = 8888
          }
          port "jenkins" {
            static = 50000
          }
        }
      }

      service {
        name = "jenkins"
        port = "http"
      }
    }
  }
}
