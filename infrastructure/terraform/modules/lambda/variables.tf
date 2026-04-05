variable "name" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
  default = "python3.12"
}

variable "role_arn" {
  type = string
}

variable "source_dir" {
  type = string
}

variable "environment_variables" {
  type = object({
    table_name  = string
    tracking_id = string
    extra       = map(string)
  })
  default = {
    table_name  = "serverless_web_application_views"
    tracking_id = "GLOBAL_COUNTER"
    extra       = {}
  }
}

variable "tags" {
  type = map(string)
  default = {}
}
