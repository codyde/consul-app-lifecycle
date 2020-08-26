provider "consul" {
    address = "http://consul.service.consul:8500"
}

resource "consul_config_entry" "api" {
  name = "api"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "consul_config_entry" "api-nomad" {
  name = "api-nomad"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "consul_config_entry" "api-eks" {
  name = "api-eks"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "consul_config_entry" "api-eks-sr" {
 kind = "service-resolver"
 name = consul_config_entry.api-eks.name

  config_json = jsonencode({
    Redirect = {
  Service    = "api"
  Datacenter = "eks"
}
  })
}

resource "consul_config_entry" "api-nomad-sr" {
 kind = "service-resolver"
 name = consul_config_entry.api-nomad.name

  config_json = jsonencode({
    Redirect = {
  Service    = "api"
  Datacenter = "humblelabvm"
}
  })
}

resource "consul_config_entry" "api-nomad-ss" {
  kind = "service-splitter"
  name = consul_config_entry.api.name

  config_json = jsonencode({
    Splits = [
  {
    Weight  = 100
  },
  {
    Weight  = 0
    Service = "api-nomad"
  }
]
  })
}

resource "consul_config_entry" "ingress" {
  kind = "ingress-gateway"
  name = "ingress-gateway"

  config_json = jsonencode({
    Listeners = [
 {
   Port = 8080
   Protocol = "http"
   Services = [
     {
       Name = "frontend"
       Hosts = ["*"]
     }
   ]
 }
]
})
}

