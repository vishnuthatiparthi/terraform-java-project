terraform {
  backend "s3" {
    bucket  = "tombayyaaa"
    key     = "env/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
