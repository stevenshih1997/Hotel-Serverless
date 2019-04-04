resource "aws_lambda_function" "hotel_lambda_function" {
  function_name = "${var.lambda_function_name}"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "${var.aws_bucket_name}"

  s3_key = "v${var.app_version}/main.zip"

  # "index" is the filename within the zip file (index.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "index.handler"

  runtime = "nodejs8.10"

  environment {
    variables = {
      sns = "${aws_cloudformation_stack.HotelVideoStack.outputs["SNSTopicArn"]}"
    }
  }

  #role = "${aws_iam_role.lambda_exec.arn}"
  # New role from cloudformation_stack allows access to SNS
  role = "${aws_cloudformation_stack.HotelVideoStack.outputs["SNSPublishRoleArn"]}"

  depends_on = ["aws_cloudformation_stack.HotelVideoStack"]
}

resource "aws_cloudformation_stack" "HotelVideoStack" {
  name = "${var.cloudformation_stack_name}"

  parameters {
    ApplicationName = "${var.cloudformation_stack_appname}"
    EmailAddress    = "${var.cloudformation_stack_email}"
  }

  capabilities  = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
  # Allow SNS to invoke hotelLambda function
  template_body = "${file("./CloudFormation/deploy.yaml")}"
}

module "kinesis" {
  source         = "./modules/kinesisvideo"
  stream_name    = "${var.kinesis_name}"
  data_retention = "0"
  delete         = "${var.kinesis_rekognition_delete}"
}

module "stream-processor" {
  source                  = "./modules/stream-processor"
  aws_region              = "${var.region}"
  kinesis_stream_arn      = "${chomp(module.kinesis.kinesis-aws-cli-output)}"
  kinesis_data_stream_arn = "${aws_cloudformation_stack.HotelVideoStack.outputs["KinesisDataStreamArn"]}"
  rekognition_role_arn    = "${aws_cloudformation_stack.HotelVideoStack.outputs["RekognitionVideoIAM"]}"
  stream_processor_name   = "${var.stream_processor_name}"
  face_collection_id      = "${var.face_collection_id}"

  delete = "${var.kinesis_rekognition_delete}"
}

module "gateway" {
  source            = "./modules/gateway"
  namespace         = "${var.gateway_name}"
  lambda_invoke_arn = "${aws_lambda_function.hotel_lambda_function.invoke_arn}"
}

# Creates Lambda permission to allow external souce (API Gateway) to invoke this function
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.hotel_lambda_function.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${module.gateway.aws_api_gateway_deployment_execution_arn}/*/*"
}
