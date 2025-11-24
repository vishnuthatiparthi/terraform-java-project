provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::564398348890:role/assume-role"
  }
}
