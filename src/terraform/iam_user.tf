resource "aws_iam_user" "rpi_producer" {
  name = "kinesis-video-raspberry-pi-producer"
  path = "/"
}

resource "aws_iam_access_key" "rpi_producer" {
  user = "${aws_iam_user.rpi_producer.name}"
}

resource "aws_iam_user_policy" "kinesis_video" {
  name = "hotel_video_stream"
  user = "${aws_iam_user.rpi_producer.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
        "Action": [
        "kinesisvideo:DescribeStream",
        "kinesisvideo:CreateStream",
        "kinesisvideo:GetDataEndpoint",
        "kinesisvideo:PutMedia"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}