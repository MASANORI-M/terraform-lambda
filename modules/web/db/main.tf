resource "aws_dynamodb_table" "inquiry_table" {
  name = var.db_name_prefix
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = var.db_name_prefix
    Env = var.env
  }
}