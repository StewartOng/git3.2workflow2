provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "sctp-ce9-tfstate"
    key    = "stewart-s3-tf-ci.tfstate"  # Change this if needed
    region = "us-east-111"
  }
}

data "aws_caller_identity" "current" {}

locals {
  raw_prefix  = split("/", data.aws_caller_identity.current.arn)[1]
  name_prefix = replace(local.raw_prefix, "_", "-")  # Replace underscore with hyphen
  account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "s3_tf" {
  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"

  tags = {
    Name        = "Terraform S3 Bucket"
    Environment = "Dev"
  }
}
