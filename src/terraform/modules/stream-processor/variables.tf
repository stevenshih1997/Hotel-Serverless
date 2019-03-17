variable "aws_region" {}

variable "kinesis_stream_arn" {}
variable "kinesis_data_stream_arn" {}
variable "rekognition_role_arn" {}

variable "stream_processor_name" {
  default = "HotelRekognitionStreamProcessor"
}

variable "face_collection_id" {}

variable "face_match_threshold" {
  default = 85.5
}

variable "delete" {
  type        = "string"
  default     = "false"
  description = "Used to delete the the endpoint"
}
