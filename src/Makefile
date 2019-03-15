check:
				@[ "${VERSION}" ] || ( echo ">> VERSION is not set"; exit 1 )

.PHONY: check

build:
				GOOS=linux GOARCH=amd64 go build -o main main.go
				zip main.zip main
.PHONY: build

upload:
				aws s3 cp main.zip s3://terraform-serverless-hotel-lambda/v${VERSION}/main.zip

.PHONY: upload

update:
				aws lambda update-function-code --function-name hotel_function --s3-bucket terraform-serverless-hotel-lambda --s3-key v${VERSION}/main.zip

.PHONY: update

apply:
				cd ./terraform && terraform apply -var="app_version=${VERSION}" 

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