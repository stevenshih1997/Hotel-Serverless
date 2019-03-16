variable "stream_name" {}
variable "data_retention" {}

variable "delete" {
  type = "string"
  default = "false"
  description = "Used to delete the the endpoint"
}