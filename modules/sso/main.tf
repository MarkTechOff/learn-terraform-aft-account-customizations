terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
      configuration_aliases = [ aws.ssogroups ]
    }
  }
}



variable "account_id" {
    description = "account id to apply permission set"
    type = string
}

variable "group_name" {
    description = "Display name of group"
    type = string
}

variable "permissionset_name" {
    description = "Name of permission set to apply"
    type = string
}

data "aws_ssoadmin_instances" "example" {
  provider = aws.ssogroups
}

#find the SRE permission set
data "aws_ssoadmin_permission_set" "sso_permset" {
  provider = aws.ssogroups
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  name         = "${var.permissionset_name}"
}

#find the named group
data "aws_identitystore_group" "sso_group" {
  provider = aws.ssogroups
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "${var.group_name}"
  }
}

# Create permission set assignment   (group, account, permission set)
resource "aws_ssoadmin_account_assignment" "sso_assign" {
  provider = aws.ssogroups
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.sso_permset.arn

  principal_id   = data.aws_identitystore_group.sso_group.group_id
  principal_type = "GROUP"

  target_id   = "${var.account_id}"
  target_type = "AWS_ACCOUNT"
}

output "permission_set_arn" {
  value = data.aws_ssoadmin_permission_set.sso_permset.arn
}

output "group_id" {
  value = data.aws_identitystore_group.sso_group.group_id
}

