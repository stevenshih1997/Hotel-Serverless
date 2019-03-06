# Provider Config
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-1"
}

variable "aws_bucket_name" {}

# App Config
variable "app_version" {}