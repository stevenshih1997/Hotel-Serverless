# Steps
  - GOOS=linux GOARCH=amd64 go build -o main main.go
  - aws s3api create-bucket --bucket=terraform-serverless-hotel-lambda --region=us-east-1 // Only run once for creating bucket
  - aws s3 cp main.zip s3://terraform-serverless-hotel-lambda/v1.0.0/main.zip

# To Run
  - output of terraform apply contains URL

# Terraform
  - terraform apply -var-file="secret.tfvars" -var="app_version=1.0.0"

# Golang
  - go test -v ./...

# AWS Rekognition
## Create Rekognition Collection
  - `aws rekognition create-collection --collection-id hotelApiCollection --region us-east-1`
  - `aws rekognition list-collections`
    - CollectionArn: aws:rekognition:us-east-1:397984152187:collection/hotelApiCollection
## Add face you want stream to look for
  - `aws s3api create-bucket --bucket=hotel-api-faces --region=us-east-1`
  - `aws rekognition index-faces --image '{"S3Object":{"Bucket":"hotel-api-faces", "Name": "steven_shih.jpg"}}' --collection-id "hotelApiCollection" --detection-attributes "ALL" --external-image-id "steven_shih" --region us-east-1`
## Create Kinesis Stream Processor
  - `aws rekognition create-stream-processor --region us-east-1 --cli-input-json file://kinesis-settings.json`
  - Remember to jot down KinesisVideoStream arn in kinesisSettings.json
  - Save StreamProcessorArn
    - arn:aws:rekognition:us-east-1:397984152187:streamprocessor/KinesisStreamProcessor
## Start Kinesis Stream Processor
  - `aws rekognition start-stream-processor --name KinesisStreamProcessor --region us-east-1`
## Check Kinesis Stream Processor status
  - `aws rekognition list-stream-processors --region us-east-1`