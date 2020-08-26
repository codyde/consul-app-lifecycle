job "frontend" {
  datacenters = ["humblelabvm"]

  group "frontend" {
    network {
      mode = "bridge"
      port "web" {
        to = 80
      }
    }

    service {
      name = "frontend"
      port = "web"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "api"
              local_bind_port = 5000
            }
          }
        }
    }

    // check {
    //   type     = "http"
    //   path     = "/"
    //   interval = "2s"
    //   timeout  = "2s"
    // }
    }

    update {
      max_parallel     = 2
      min_healthy_time = "30s"
      healthy_deadline = "9m"
    }
    count = 3

    task "server" {
      env {
        PORT    = "${NOMAD_PORT_http}"
        NODE_IP = "${NOMAD_IP_http}"
      }

      driver = "docker"

      config {
        image = "codydearkland/frontend-v4:latest"
      
        // port_map {
        //   web = 80
        // }

        volumes = [
          "local2:/etc/nginx/conf.d",
        ]
      }

      template {
        data = <<EOF
        server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    
    location /api {
    proxy_pass http://localhost:5000/api;
    proxy_read_timeout 300s;
    proxy_connect_timeout 75s;
    proxy_http_version 1.1;
    proxy_set_header Upgrade    $http_upgrade;
    proxy_set_header Connection $http_connection;
    proxy_set_header Host       $host;
    proxy_cache_bypass $http_upgrade;
  }

  location /socket.io {
    proxy_http_version 1.1;
    proxy_buffering off;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_set_header Host       $host;
    proxy_cache_bypass $http_upgrade;
    proxy_pass http://localhost:5000/socket.io;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}
EOF
        destination   = "local2/load-balancer.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      // resources {
      //   network {
      //     port  "80"{}
      //   }
      // }

      
    }
  }
}