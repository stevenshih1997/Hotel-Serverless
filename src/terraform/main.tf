# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket = "${var.aws_bucket_name}"

#   #Enable when destroying all infrastructure
#   force_destroy = true
# }

resource "aws_lambda_function" "hotel_lambda_function" {
  function_name = "${var.lambda_function_name}"

  #filename = "main.zip"
  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "${var.aws_bucket_name}"

  s3_key = "v${var.app_version}/main.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
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
  name = "HotelVideoStack"

  parameters {
    ApplicationName = "HotelAPIVideo"
    EmailAddress    = "stevenshih1997@gmail.com"
  }

  capabilities  = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
  template_body = "${file("./CloudFormation/deploy.yaml")}"
}

module "kinesis" {
  source         = "./modules/kinesis"
  stream_name    = "HotelSecurityStream"
  data_retention = "2"
  delete         = "${var.kinesis_rekognition_delete}"
}

module "stream-processor" {
  source                  = "./modules/stream-processor"
  aws_region              = "${var.region}"
  kinesis_stream_arn      = "${chomp(module.kinesis.kinesis-aws-cli-output)}"
  kinesis_data_stream_arn = "${aws_cloudformation_stack.HotelVideoStack.outputs["KinesisDataStreamArn"]}"
  rekognition_role_arn    = "${aws_cloudformation_stack.HotelVideoStack.outputs["RekognitionVideoIAM"]}"
  stream_processor_name   = "HotelRekognitionStreamProcessor"
  face_collection_id      = "hotelApiCollection"

  delete = "${var.kinesis_rekognition_delete}"

  #depends_on = ["module.kinesis", "aws_cloudformation_stack.HotelVideoStack"]
}

module "gateway" {
  source            = "./modules/gateway"
  namespace         = "hotel_api_gateway"
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
