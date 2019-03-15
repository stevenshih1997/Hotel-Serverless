# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_hotel_lambda"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# resource "aws_iam_policy" "write_policy" {
#   name        = "hotel-api-stream-write-policy"
#   description = "Policy allowing put record/records to a Kinesis Stream"

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "kinesis:PutRecord",
#                 "kinesis:PutRecords"
#             ],
#             "Resource": [
#                 "arn:aws:kinesis:${var.region}:${data.aws_caller_identity.current.account_id}:stream/hotel-api-stream"
#             ]
#         }
#     ]
# }
# EOF
# }
resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}


# resource "aws_iam_role_policy_attachment" "kinesis_video_stream_write_policy" {
#   role = "${aws_iam_role.lambda_exec.name}"
#   policy_arn = "${aws_iam_policy.kinesis_video.arn}"
# }

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "${aws_iam_role.lambda_exec.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

# Jenkins Slave profile
# resource "aws_iam_instance_profile" "worker_profile" {
#   name = "JenkinsWorkerProfile"
#   role = "${aws_iam_role.worker_role.name}"
# }

# resource "aws_iam_role" "worker_role" {
#   name = "JenkinsBuildRole"
#   path = "/"

#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": "sts:AssumeRole",
#             "Principal": {
#                "Service": "ec2.amazonaws.com"
#             },
#             "Effect": "Allow",
#             "Sid": ""
#         }
#     ]
# }
# EOF
# }
# resource "aws_iam_policy" "lambda_policy" {
#   name = "DeployLambdaPolicy"
#   path = "/"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "lambda:UpdateFunctionCode",
#         "lambda:PublishVersion",
#         "lambda:UpdateAlias"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "worker_s3_attachment" {
#   role       = "${aws_iam_role.worker_role.name}"
#   policy_arn = "${aws_iam_policy.s3_policy.arn}"
# }

# resource "aws_iam_role_policy_attachment" "worker_lambda_attachment" {
#   role       = "${aws_iam_role.worker_role.name}"
#   policy_arn = "${aws_iam_policy.lambda_policy.arn}"
# }

# # S3 Role
# resource "aws_iam_policy" "s3_policy" {
#   name = "PushToS3Policy"
#   path = "/"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:PutObject",
#         "s3:GetObject"
#       ],
#       "Effect": "Allow",
#       "Resource": "${aws_s3_bucket.lambda_bucket.arn}/*"
#     }
#   ]
# }
# EOF
# }