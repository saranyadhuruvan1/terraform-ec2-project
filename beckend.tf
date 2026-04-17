terraform {
  backend "s3" {
    bucket         = "saranya-terraform-state-001"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}