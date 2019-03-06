package main

import (
	"fmt"
	"log"
	"strconv"
	"encoding/json"

	"github.com/stevenshih1997/hotel_api/model"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)


// var (
// 	// ErrNameNotProvided is thrown when a name is not provided
// 	ErrNameNotProvided = errors.New("no name was provided in the HTTP body")
// )


func fibonacci(n int) int {
	if n <= 1 {
		return n
	}
	return fibonacci(n-1) + fibonacci(n-2)
}

func getTest(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	result := fibonacci(5)
	resultString := strconv.Itoa(result)
	return events.APIGatewayProxyResponse{
		Body:      resultString,
		StatusCode: 200,
	}, nil
}
// insert request json payload into new device
func makeNewDevice(PayloadJSON map[string]interface{}) model.Device {
	return model.Device{
		ID:          PayloadJSON["id"].(string),
		DeviceModel: PayloadJSON["deviceModel"].(string),
		Name:        PayloadJSON["name"].(string),
		Note:        PayloadJSON["note"].(string),
		Serial:      PayloadJSON["serial"].(string),
	}
}

func postTest(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	//var PostRequestJson map[string]interface{}

	return events.APIGatewayProxyResponse{
		Body:       "post" + request.Body,
		StatusCode: 200,
	}, nil
}

func router(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	switch request.HTTPMethod {
	case "GET":
			return getTest(request)
	case "POST":
			return postTest(request)
	default:
			return getTest(request)
	}
}
// Handler is your Lambda function handler
// It uses Amazon API Gateway request/responses provided by the aws-lambda-go/events package,
// However you could use other event sources (S3, Kinesis etc), or JSON-decoded primitive types such as 'string'.
func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	// stdout and stderr are sent to AWS CloudWatch Logs
	log.Printf("Processing Lambda request %s\n", request.RequestContext.RequestID)

	// If no name is provided in the HTTP request body, throw an error
	// if len(request.Body) < 1 {
	// 	return events.APIGatewayProxyResponse{}, ErrNameNotProvided
	// }
	var PostRequestJson map[string]interface{}
	json.Unmarshal([]byte(request.Body), &PostRequestJson)

	device := makeNewDevice(PostRequestJson)
	deviceJSON, err := json.Marshal(device)

	if err != nil {
		return events.APIGatewayProxyResponse{
			Body:       "Error",
			StatusCode: 500,
		}, nil
	}

	fmt.Println(request.QueryStringParameters)

	return events.APIGatewayProxyResponse{
		Body:       string(deviceJSON) + string(request.Body),
		StatusCode: 200,
	}, nil

}

func main() {
	lambda.Start(router)
}