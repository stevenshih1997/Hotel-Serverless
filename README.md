# Steps
  - GOOS=linux GOARCH=amd64 go build -o main main.go
  - aws s3api create-bucket --bucket=terraform-serverless-hotel-api --region=us-east-1 // Only run once for creating bucket
  - aws s3 cp main.zip s3://terraform-serverless-hotel-lambda/v1.0.0/main.zip

# To Run
  - output of terraform apply contains URL

# Terraform
  - terraform apply -var-file="secret.tfvars" -var="app_version=1.0.0"

# Golang
  - go test -v ./...