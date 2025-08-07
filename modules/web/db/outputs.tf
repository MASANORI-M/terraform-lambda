output "table_name" {
  value = aws_dynamodb_table.inquiry_table.name
}

output "table_arn" {
  value = aws_dynamodb_table.inquiry_table.arn
}