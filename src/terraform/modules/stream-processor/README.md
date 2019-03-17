## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_region |  | string | n/a | yes |
| delete | Used to delete the the endpoint | string | `"false"` | no |
| face\_collection\_id |  | string | n/a | yes |
| face\_match\_threshold |  | string | `"85.5"` | no |
| kinesis\_data\_stream\_arn |  | string | n/a | yes |
| kinesis\_stream\_arn |  | string | n/a | yes |
| rekognition\_role\_arn |  | string | n/a | yes |
| stream\_processor\_name |  | string | `"HotelRekognitionStreamProcessor"` | no |

## Outputs

| Name | Description |
|------|-------------|
| rekognition-stream-aws-cli-output |  |

