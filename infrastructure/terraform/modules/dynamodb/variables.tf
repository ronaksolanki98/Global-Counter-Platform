variable "table_name" {
  type = string
}

variable "partition_key" {
  type    = string
  default = "id"
}

variable "partition_type" {
  type    = string
  default = "S"
}

variable "tags" {
  type    = map(string)
  default = {}
}
