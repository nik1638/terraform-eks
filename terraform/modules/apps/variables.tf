variable "namespace" {
  type    = string
  default = "infra"
}

variable "values" {
  type = map(any)
  default = {}
}


