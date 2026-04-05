locals {
  common_tags = {
    project     = "serverless-counter"
    environment = var.environment
  }
}

module "dynamodb" {
  source       = "./modules/dynamodb"
  table_name   = "serverless_web_application_views"
  tags         = local.common_tags
}

module "iam" {
  source               = "./modules/iam"
  name_prefix          = "serverless-counter"
  dynamodb_table_arn   = module.dynamodb.table_arn
  tags                 = local.common_tags
}

module "lambda" {
  source         = "./modules/lambda"
  name           = "serverless-counter-handler-${var.environment}"
  handler        = "app.backend.handler.lambda_handler"
  role_arn       = module.iam.role_arn
  source_dir     = "${path.root}/../../app/backend"
  environment_variables = {
    table_name  = module.dynamodb.table_name
    tracking_id = "GLOBAL_COUNTER"
    extra       = {
      AWS_REGION = var.aws_region
    }
  }
  tags = local.common_tags
}
