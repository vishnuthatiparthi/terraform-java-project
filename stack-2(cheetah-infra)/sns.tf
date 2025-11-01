module "sns" {
  source = "./localmodules/sns"

  envname             = var.env_name
  lambda_function_arn = module.lambda.lambda_func_arn
}