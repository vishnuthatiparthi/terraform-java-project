data "terraform_remote_state" "app_buckets" {
  backend = "s3"

  config = {
    bucket = "tombayyaaa"
    key    = "env/dev/terraform.tfstate"
    region = "us-east-1"
  }
}