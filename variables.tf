variable "image_name" {
  type    = string
  default = "controller:latest"
}

variable "resource" {
  type = list(object({
    domain  = string
    group   = string
    version = string
    kind    = string
  }))
}
