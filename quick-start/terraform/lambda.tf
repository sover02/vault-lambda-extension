resource "aws_lambda_function" "function" {
  function_name = "${var.environment_name}-function"
  description   = "Demo Vault AWS Lambda extension"
  role          = aws_iam_role.lambda.arn
  filename      = "../demo-function/demo-function.zip"
  handler       = "main"
  runtime       = "provided.al2"
  architectures = ["x86_64"]
  layers        = ["arn:aws:lambda:${var.aws_region}:634166935893:layer:vault-lambda-extension:12"]

  environment {
    variables = {
      VAULT_ADDR           = "http://${aws_instance.vault-server.public_ip}:8200",
      VAULT_AUTH_ROLE      = aws_iam_role.lambda.name,
      VAULT_AUTH_PROVIDER  = "aws",
      VAULT_SECRET_PATH_DB = "database/creds/lambda-function",
      VAULT_SECRET_FILE_DB = "/tmp/vault_secret.json",
      VAULT_SECRET_PATH    = "secret/myapp/config",
      DATABASE_URL         = aws_db_instance.main.address
    }
  }
}
