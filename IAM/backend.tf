/*
terraform {
  backend "s3" {
    bucket = "all-terraform-state-files-ap-southeast-1"
    key    = "user-creation-resources/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = "true"
    dynamodb_table = "terraformstate"
  }
}
*/