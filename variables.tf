variable "image_name" {
  type    = string
  default = "controller:latest"
}

variable "resources" {
  type = list(object({
    domain  = string
    group   = string
    version = string
    kind    = string
  }))
}
