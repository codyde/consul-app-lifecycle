provider "nomad" {
  address = "http://nomad.service.consul:4646"
}

resource "nomad_job" "jenkins" {
  jobspec = file("${path.module}/jenkins.hcl")
}

resource "nomad_job" "app" {
  jobspec = file("${path.module}/nomad-app.hcl")
}

resource "nomad_job" "lb" {
  jobspec = file("${path.module}/nginx.hcl")
}

resource "nomad_job" "api" {
  jobspec = file("${path.module}/api.hcl")
}

resource "nomad_job" "db" {
  jobspec = file("${path.module}/db.hcl")
}
