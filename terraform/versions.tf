terraform {
  required_version = "~>= 1.9.5"
  backend "s3" {
    bucket = "gitops2024-tf-backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "Gitops2024TerraformLocks"
  }
}
