# Provider Config
provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "/Users/stevenshih/.aws/credentials"
}

variable "region" {
  default = "us-east-1"
}

variable "aws_bucket_name" {}

variable "lambda_function_name" {}

# App Config
variable "app_version" {}

# Kinesis stream and rekognition stream status

variable "kinesis_rekognition_delete" {}

variable "cloudformation_stack_name" {}

variable "cloudformation_stack_appname" {}

variable "cloudformation_stack_email" {}

variable "kinesis_name" {}

variable "gateway_name" {}

variable "stream_processor_name" {}

variable "face_collection_id" {}
