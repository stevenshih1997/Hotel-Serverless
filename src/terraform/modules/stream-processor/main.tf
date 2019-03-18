resource "null_resource" "create-stream-processor" {
  count = "${var.delete != "false" ? 0 : 1}"

  provisioner "local-exec" {
    command = <<EOF
      aws rekognition create-stream-processor --region ${var.aws_region} --cli-input-json \
      "{
      \"Input\": {
          \"KinesisVideoStream\": {
              \"Arn\": \"${var.kinesis_stream_arn}\"
          }
      },
      \"Output\": {
          \"KinesisDataStream\": {
              \"Arn\": \"${var.kinesis_data_stream_arn}\"
          }
      },
      \"Name\": \"${var.stream_processor_name}\",
      \"Settings\": {
          \"FaceSearch\": {
              \"CollectionId\": \"${var.face_collection_id}\",
              \"FaceMatchThreshold\": ${var.face_match_threshold}
          }
      },
      \"RoleArn\": \"${var.rekognition_role_arn}\"
      }" | jq -r -j '.StreamProcessorArn' > ${data.template_file.stream_processor_log_name.rendered} \
      && aws rekognition start-stream-processor --name "${var.stream_processor_name}" --region ${var.aws_region}
    EOF
  }
}

resource "null_resource" "delete-stream-processor" {
  count = "${var.delete != "false" ? 1 : 0}"

  provisioner "local-exec" {
    command = <<EOF
      aws rekognition stop-stream-processor --name ${var.stream_processor_name} --region ${var.aws_region} \
      && aws rekognition delete-stream-processor --name ${var.stream_processor_name}
  EOF
  }

  depends_on = ["null_resource.create-stream-processor"]
}

#-------------------------------------------------------------------------------------

data "template_file" "stream_processor_log_name" {
  template = "${path.module}/output.log"
}

data "local_file" "create-stream-processor" {
  filename = "${data.template_file.stream_processor_log_name.rendered}"
}
