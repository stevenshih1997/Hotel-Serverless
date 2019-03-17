output "kinesis-aws-cli-output" {
  value = "${data.local_file.create-kinesis-stream.content}"
}
