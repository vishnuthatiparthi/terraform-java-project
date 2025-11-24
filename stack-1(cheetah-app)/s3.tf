resource "aws_s3_bucket" "be_app_bucket" {
  bucket = "cheetah-${var.envname}-be-app-bucket-demo"
}

resource "aws_s3_bucket" "fe_app_bucket" {
  bucket = "cheetah-${var.envname}-fe-app-bucket-demo"
}