resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.aws_bucket_name}"

  force_destroy = true
}

resource "aws_lambda_function" "hotel_lambda_function" {
  function_name = "${var.lambda_function_name}"
  #filename = "main.zip"
  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "${aws_s3_bucket.lambda_bucket.id}"
  s3_key    = "v${var.app_version}/main.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main"
  runtime = "go1.x"

  role = "${aws_iam_role.lambda_exec.arn}"
}

module "gateway" {
  source = "./modules/gateway"
  namespace = "hotel_api_gateway"
  lambda_invoke_arn = "${aws_lambda_function.hotel_lambda_function.invoke_arn}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hotel_lambda_function.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${module.gateway.aws_api_gateway_deployment_execution_arn}/*/*"
}

