data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "production_bucket" {
  bucket = "aft-prod-${data.aws_caller_identity.current.account_id}"
  acl    = "private"
}
