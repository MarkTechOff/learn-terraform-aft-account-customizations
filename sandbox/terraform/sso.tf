data "aws_ssoadmin_instances" "example" {
  provider = aws.ssogroups
}

data "aws_ssoadmin_permission_set" "example" {
  provider = aws.ssogroups
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  name         = "AWSReadOnlyAccess"
}

data "aws_identitystore_group" "example" {
  provider = aws.ssogroups
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "NGLZ_AD_SYNC@microfocusdev.com"
  }
}

data "aws_caller_identity" "current_acct" {}

resource "aws_ssoadmin_account_assignment" "example" {
  provider = aws.ssogroups
  instance_arn       = data.aws_ssoadmin_permission_set.example.instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.example.arn

  principal_id   = data.aws_identitystore_group.example.group_id
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.current_acct.account_id
  target_type = "AWS_ACCOUNT"
}
