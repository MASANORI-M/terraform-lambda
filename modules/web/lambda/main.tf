data "archive_file" "lambda_zip" {
  type = "zip"
  source_dir = "${path.module}/lambda_function"
  output_path = "${path.module}/lambda_function.zip"
}

data "aws_iam_role" "existing" {
  name = "lambda-apigateway-role"
}

resource "aws_lambda_function" "this" {
  function_name = var.lambda_name_prefix
  role = data.aws_iam_role.existing.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.13"
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  timeout = 10

  tags = {
    Name = var.lambda_name_prefix
    Env = var.env
  }
}