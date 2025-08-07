resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name_prefix
  description = "REST API for ${var.api_name_prefix}"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# resource "aws_api_gateway_resource" "root_resource" {
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   parent_id = aws_api_gateway_rest_api.api.root_resource_id
#   path_part = ""
# }

resource "aws_api_gateway_method" "post_method" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id
  http_method = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_invoke_arn}/invocations"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name = "inquerytest"
}

resource "aws_lambda_permission" "allow_apigw" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.lambda_invoke_arn
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}