# Provider Config
provider "aws" {
  region     = "${var.region}"
  shared_credentials_file = "/Users/stevenshih/.aws/credentials"
}
variable "region" {
  default = "us-east-1"
}

variable "aws_bucket_name" {}

variable "lambda_function_name" {}

# App Config
variable "app_version" {}