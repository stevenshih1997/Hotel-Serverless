# Workflow
  - Go inside `src` directory
  - `make apply VERSION=1.0.0` to spin up all terraform aws instances
  - `make destroy VERSION=1.0.0` to destroy all instances
  - To only spin down the kinesis instances, run `make streamdown VERSION=1.0.0`
  - To spin up kinesis instances after they are down, run `make apply VERSION=1.0.0`

# Additional notes
  - If there are errors with `make apply` and `terraform init`, run `terraform get -update`
  - After `make destroy` is run:
    - a new raspberry pi id and secret must be copied over and `source ~/.bashrc` must be run
    - Additionally, SNS email must be reconfirmed/resubscribed
    - Also remember to change URL in Google Cloud server after destroying infrastructure
    - If camera is unplugged, run `ls /dev/video*` if "No such file or directory" appears, run `vcgencmd get_camera` and then `sudo modprobe bcm2835-v4l2`. Check `ls /dev/video*`, and the output should be `/dev/video0`.
  - Remember to enable 'VideoStackLambda' function to consume kinesis data stream if initially disabled (due to saving credits).

# Infrastructure Diagram
![AWS Infrastructure](src/assets/architecture.png?raw=true "AWS Infrastructure")

# Overall Infrastructure Diagram
![Overall Infrastructure](src/assets/hotelArchitecture.png?raw=true "Overall Infrastructure")
# Dependencies
  - aws cli
  - jq

# My Notes
  - GOOS=linux GOARCH=amd64 go build -o main main.go
  - aws s3api create-bucket --bucket=terraform-serverless-hotel-lambda --region=us-east-1 // Only run once for creating bucket
  - aws s3 cp main.zip s3://terraform-serverless-hotel-lambda/v1.0.0/main.zip
  - ASSUMPTION: AWS s3 buckets are already created
  - `terraform refresh -update` to fix errors with loading modules
  - Utilize `terraform plan` and `terraform plan -destroy` to check before actually applying

## AWS Rekognition
### Create Rekognition Collection
  - `aws rekognition create-collection --collection-id hotelApiCollection --region us-east-1`
  - `aws rekognition list-collections`
    - CollectionArn: aws:rekognition:us-east-1:397984152187:collection/hotelApiCollection
### Add face you want stream to look for (already in s3 bucket)
  - `aws s3api create-bucket --bucket=hotel-api-faces --region=us-east-1`
  - `aws rekognition index-faces --image '{"S3Object":{"Bucket":"hotel-api-faces", "Name": "<image-name>.jpg"}}' --collection-id "hotelApiCollection" --detection-attributes "ALL" --external-image-id "<image name without extension>" --region us-east-1`
### Create Rekognition Stream Processor
  - Kinesis Stream Name: HotelSecurityStream
  - `aws rekognition create-stream-processor --region us-east-1 --cli-input-json file://kinesis-settings.json`
  - This will be need to run everytime a kinesis video stream is created and destroyed, with its unique arn in kinesis-settings.json, since a kinesis video stream is charged by the hour.
  - Remember to jot down KinesisVideoStream arn in kinesisSettings.json
  - Save StreamProcessorArn
    - arn:aws:rekognition:us-east-1:397984152187:streamprocessor/KinesisStreamProcessor
### Start Rekognition Stream Processor
  - `aws rekognition start-stream-processor --name KinesisStreamProcessor --region us-east-1`
### Stop Rekognition Stream Processor
  - `aws rekognition stop-stream-processor --name KinesisStreamProcessor --region us-east-1`
### Delete Rekognition Stream Processor
  - `aws rekognition delete-stream-processor --name KinesisStreamProcessor`
### Check Rekognition Stream Processor status
  - `aws rekognition list-stream-processors --region us-east-1`

### Create Kinesis Video Stream
  - `aws kinesisvideo create-stream --stream-name "HotelSecurityStream" --data-retention-in-hours "2"`
  - Output is stream ARN
  - Need to store this arn for use in rekognition stream processor
  - maybe in temp file so destroying the two streams are easily done

### Delete Kinesis Video Stream
  - `aws kinesisvideo delete-stream --stream-arn "arn:aws:kinesisvideo:us-east-1:397984152187:stream/HotelSecurityStream/1552674155145"`

### Describe Kinesis Video Stream
  - `aws kinesisvideo describe-stream --stream-name "HotelSecurityStream"`