variable "name_prefix" {
  type = string
}

variable "dynamodb_table_arn" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}
