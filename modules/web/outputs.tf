output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "lambda_name" {
  value = module.lambda.lambda_name
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "api_gateway_rest_url" {
  value = module.apigateway.api_url
}