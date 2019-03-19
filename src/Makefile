# CHECKS IF VARIABLES ARE SET
check:
				@[ "${VERSION}" ] || ( echo ">> VERSION is not set"; exit 1 )

.PHONY: check

checkImage:
				@[ "${IMAGE}" ] || ( echo ">> IMAGE is not set"; exit 1 )

.PHONY: checkImage

# COMMANDS FOR LAMBDA CONNECTED TO API GATEWAY
buildGatewayApi:
				zip ./gatewayApi/main.zip ./gatewayApi/index.js

.PHONY: buildGatewayApi

uploadGatewayApi:
				make check
				aws s3 cp ./gatewayApi/main.zip s3://terraform-serverless-hotel-lambda/v${VERSION}/main.zip

.PHONY: uploadGatewayApi

updateGatewayApi:
				aws lambda update-function-code --function-name hotel_function --s3-bucket terraform-serverless-hotel-lambda --s3-key v${VERSION}/main.zip

.PHONY: updateGatewayApi

gatewayApi:
				make check
				make build
				make upload
				make update

.PHONY: gatewayApi

# COMMANDS FOR LAMBDA CONNECTED TO AWS REKOGNITION
buildHotelLambda:
				zip -j ./hotelLambda/Lambda.zip ./hotelLambda/index.js

.PHONY: buildHotelLambda

uploadHotelLambda:
				aws s3 cp ./hotelLambda/Lambda.zip s3://terraform-serverless-hotel-lambda/KinesisVideoRekognition/Lambda.zip

.PHONY: uploadHotelLambda

updateHotelLambda:
				aws lambda update-function-code --function-name HotelVideoStack-RekognitionVideoLambda-1KK0B36Y6MI5Y --s3-bucket terraform-serverless-hotel-lambda --s3-key KinesisVideoRekognition/Lambda.zip

.PHONY: updateHotelLambda

hotelLambda:
				make buildHotelLambda
				make uploadHotelLambda
				make updateHotelLambda

.PHONY: hotelLambda

# COMMANDS FOR TERRAFORM INFRASTRUCTURE
apply:
				cd ./terraform && terraform apply -var="app_version=${VERSION}" -var="kinesis_rekognition_delete=false"

.PHONY: apply

streamdown:
				cd ./terraform && terraform apply -var="app_version=${VERSION}" -var="kinesis_rekognition_delete=true"

.PHONY: streamdown

destroy:
				make streamdown
				cd ./terraform && terraform destroy -var="app_version=${VERSION}" -var="kinesis_rekognition_delete=false"

.PHONY: destroy

# COMMAND FOR ADDING FACE TO REKOGNITION DATABASE
addface:
				# Put image under assets/faces
				# IMAGE is the image file with extension
				make checkImage
				aws s3 cp ./assets/faces/${IMAGE} s3://hotel-api-faces/${IMAGE}
				aws rekognition index-faces --image '{"S3Object":{"Bucket":"hotel-api-faces", "Name": "${IMAGE}"}}' --collection-id "hotelApiCollection" --detection-attributes "ALL" --external-image-id "$(basename ${IMAGE})" --region us-east-1

.PHONY: addface
