output "base_url" {
#  value = "${aws_api_gateway_deployment.hotel_api_gateway_deployment.invoke_url}"
  value = "${module.gateway.aws_api_gateway_deployment_invoke_url}"
}

output "uploaded_bucket_name" {
  value = "${aws_s3_bucket.lambda_bucket.id}"
}