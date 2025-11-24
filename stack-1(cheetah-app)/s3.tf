resource "aws_s3_bucket" "be_app_bucket" {
  bucket = "cheetah-dev-be-app-bucket-demo"
}

resource "aws_s3_bucket" "fe_app_bucket" {
  bucket = "cheetah-dev-fe-app-bucket-demo"
}