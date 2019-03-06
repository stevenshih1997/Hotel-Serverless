package main

import (
	"context"

	"github.com/aws/aws-lambda-go/events"
)

// HandlerAPIGateway is an API Gateway Proxy Request handler function
type HandlerAPIGateway func(context.Context, events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error)

// NotifyAPIGateway wraps a handler func and sends an SNS notification on error
func NotifyAPIGateway(h HandlerAPIGateway) HandlerAPIGateway {
	return func(ctx context.Context, e events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
		r, err := h(ctx, e)
		return r, err
	}
}
