resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.hotel_api_gateway.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.hotel_api_gateway.id}"
  resource_id   = "${aws_api_gateway_rest_api.hotel_api_gateway.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}