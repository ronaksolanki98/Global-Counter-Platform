output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "lambda_function_name" {
  value = module.lambda.lambda_name
}
