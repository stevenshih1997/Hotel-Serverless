output "aws_api_gateway_deployment_execution_arn" {
  value = "${aws_api_gateway_deployment.hotel_api_gateway_deployment.execution_arn}"
}
output "aws_api_gateway_deployment_invoke_url" {
  value = "${aws_api_gateway_deployment.hotel_api_gateway_deployment.invoke_url}"
}