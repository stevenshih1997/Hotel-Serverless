# output "base_url" {
#   #  value = "${aws_api_gateway_deployment.hotel_api_gateway_deployment.invoke_url}"
#   value = "${module.gateway.aws_api_gateway_deployment_invoke_url}"
# }

# output "uploaded_bucket_name" {
#   value = "${aws_s3_bucket.lambda_bucket.id}"
# }

output "rpi_user_secret" {
  value = "${aws_iam_access_key.rpi_producer.secret}"
}

output "rpi_user_id" {
  value = "${aws_iam_access_key.rpi_producer.id}"
}

output "KinesisDataStreamArn" {
  value       = "${aws_cloudformation_stack.HotelVideoStack.outputs["KinesisDataStreamArn"]}"
  description = "Kinesis Data Stream Arn (used in Stream Processer Input)"
}

output "RekognitionVideoIAM" {
  value       = "${aws_cloudformation_stack.HotelVideoStack.outputs["RekognitionVideoIAM"]}"
  description = "Rekognition Video Processing IAM Arn (used in Stream Processer Input)"
}

# GATEWAY MODULE
output "aws_api_gateway_deployment_execution_arn" {
  value = "${module.gateway.aws_api_gateway_deployment_execution_arn}"
}

output "aws_api_gateway_deployment_invoke_url" {
  value = "${module.gateway.aws_api_gateway_deployment_invoke_url}"
}

# KINESIS MODULE
output "kinesis-aws-cli-output" {
  value = "${module.kinesis.kinesis-aws-cli-output}"
}

# STREAM PROCESSOR MODULE
output "rekognition-stream-aws-cli-output" {
  value = "${module.stream-processor.rekognition-stream-aws-cli-output}"
}
