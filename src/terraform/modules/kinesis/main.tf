resource "null_resource" "create-kinesis-stream" {
  count = "${var.delete != "false" ? 0 : 1}"

  provisioner "local-exec" {
    command = "aws kinesisvideo create-stream --stream-name ${var.stream_name} --data-retention-in-hours ${var.data_retention} | jq -r -j '.StreamARN'  > ${data.template_file.kinesis_log_name.rendered}"
  }
}

resource "null_resource" "describe-stream" {
  provisioner "local-exec" {
    command = "aws kinesisvideo describe-stream --stream-name ${var.stream_name} > ${data.template_file.kinesis-stream-id.rendered}"
  }

  depends_on = ["null_resource.create-kinesis-stream"]
}

resource "null_resource" "delete-kinesis-stream" {
  count = "${var.delete != "false" ? 1 : 0}"

  provisioner "local-exec" {
    command = "aws kinesisvideo delete-stream --stream-arn ${trimspace(data.local_file.create-kinesis-stream.content)}" #" > ${data.template_file.kinesis_log_name.rendered}"
  }

  depends_on = ["null_resource.create-kinesis-stream"]
}

#-------------------------------------------------------------------------------------

data "template_file" "kinesis_log_name" {
  template = "${path.module}/output.log"
}

data "template_file" "kinesis-stream-id" {
  template = "${path.module}/id.log"
}

data "local_file" "create-kinesis-stream" {
  filename = "${data.template_file.kinesis_log_name.rendered}"
}

data "local_file" "describe-kinesis-stream" {
  filename = "${data.template_file.kinesis-stream-id.rendered}"
}
