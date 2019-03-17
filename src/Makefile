check:
				@[ "${VERSION}" ] || ( echo ">> VERSION is not set"; exit 1 )

.PHONY: check

build:
				zip main.zip index.js

.PHONY: build

upload:
				aws s3 cp main.zip s3://terraform-serverless-hotel-lambda/v${VERSION}/main.zip

.PHONY: upload

update:
				aws lambda update-function-code --function-name hotel_function --s3-bucket terraform-serverless-hotel-lambda --s3-key v${VERSION}/main.zip

.PHONY: update

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

compile:
				make check
				make build
				make upload
				make update

.PHONY: compile

all:		
				make check
				make build
				make upload
				make apply

.PHONY: all
