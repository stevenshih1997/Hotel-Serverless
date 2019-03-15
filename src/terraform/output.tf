output "base_url" {
#  value = "${aws_api_gateway_deployment.hotel_api_gateway_deployment.invoke_url}"
  value = "${module.gateway.aws_api_gateway_deployment_invoke_url}"
}

output "uploaded_bucket_name" {
  value = "${aws_s3_bucket.lambda_bucket.id}"
}

# output "secret" {
#   value = "${aws_iam_access_key.rpi_producer.secret}"
# }

output "KinesisDataStreamArn" {
    value = "${aws_cloudformation_stack.HotelVideoStack.outputs["KinesisDataStreamArn"]}"
    description = "Kinesis Data Stream Arn (used in Stream Processer Input)"
}


output "RekognitionVideoIAM" {
  value = "${aws_cloudformation_stack.HotelVideoStack.outputs["RekognitionVideoIAM"]}"
  description = "Rekognition Video Processing IAM Arn (used in Stream Processer Input)"
}