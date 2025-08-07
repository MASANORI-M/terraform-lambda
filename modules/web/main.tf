provider "aws" {
  region = "ap-northeast-1"
}

locals {
  api_name = "inquiryAPI"
  lambda_name = "UploadInquiry"
  db_name = "InquiryTable"
  api_name_prefix = "${var.env}-${local.api_name}"
  lambda_name_prefix = "${var.env}-${local.lambda_name}"
  db_name_prefix  = "${var.env}-${local.db_name}"
}

module "dynamodb" {
  source = "./db"
  env = var.env
  db_name_prefix = local.db_name_prefix
}

module "lambda" {
  source = "./lambda"
  env = var.env
  lambda_name_prefix = local.lambda_name_prefix
}

module "apigateway" {
  source = "./apigateway"
  env = var.env
  api_name_prefix = local.api_name_prefix
  lambda_invoke_arn = module.lambda.lambda_arn
  region = var.region
}