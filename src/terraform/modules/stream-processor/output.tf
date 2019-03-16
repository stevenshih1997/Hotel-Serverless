output "rekognition-stream-aws-cli-output" {
  value = "${data.local_file.create-stream-processor.content}"
}