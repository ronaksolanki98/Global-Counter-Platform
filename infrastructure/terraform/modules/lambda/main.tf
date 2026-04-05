data "archive_file" "package" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/../../packages/${var.name}.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = var.name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  filename      = data.archive_file.package.output_path
  source_code_hash = data.archive_file.package.output_base64sha256
  publish       = true

  environment {
    variables = merge({
      TABLE_NAME  = var.environment_variables.table_name,
      TRACKING_ID = var.environment_variables.tracking_id
    }, var.environment_variables.extra)
  }

  tags = var.tags
}
