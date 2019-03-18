## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_version | App Config | string | n/a | yes |
| aws\_bucket\_name |  | string | n/a | yes |
| cloudformation\_stack\_appname |  | string | n/a | yes |
| cloudformation\_stack\_email |  | string | n/a | yes |
| cloudformation\_stack\_name |  | string | n/a | yes |
| face\_collection\_id |  | string | n/a | yes |
| gateway\_name |  | string | n/a | yes |
| kinesis\_name |  | string | n/a | yes |
| kinesis\_rekognition\_delete |  | string | n/a | yes |
| lambda\_function\_name |  | string | n/a | yes |
| region |  | string | `"us-east-1"` | no |
| stream\_processor\_name |  | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| KinesisDataStreamArn | Kinesis Data Stream Arn (used in Stream Processer Input) |
| RekognitionVideoIAM | Rekognition Video Processing IAM Arn (used in Stream Processer Input) |
| aws\_api\_gateway\_deployment\_execution\_arn | GATEWAY MODULE |
| aws\_api\_gateway\_deployment\_invoke\_url |  |
| kinesis-aws-cli-output | KINESIS MODULE |
| rekognition-stream-aws-cli-output | STREAM PROCESSOR MODULE |
| rpi\_user\_id |  |
| rpi\_user\_secret |  |

