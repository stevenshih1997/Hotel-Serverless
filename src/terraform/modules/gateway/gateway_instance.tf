resource "aws_api_gateway_rest_api" "hotel_api_gateway" {
  name        = "${var.namespace}"
  description = "Terraform Serverless Hotel Application"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.hotel_api_gateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.hotel_api_gateway.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.hotel_api_gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.hotel_api_gateway.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  #uri                     = "${aws_lambda_function.hotel_lambda_function.invoke_arn}"
  uri = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_deployment" "hotel_api_gateway_deployment" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.hotel_api_gateway.id}"
  stage_name  = "api"
  description = "Deployed at ${timestamp()}"
}
