resource "aws_budgets_budget" "total_cost" {
  name              = "budget-total-monthly"
  budget_type       = "COST"
  limit_amount      = "50"
  limit_unit        = "USD"
  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2022-02-01_00:00"
  time_unit         = "MONTHLY"
}


module "sso_permissions" {
    source = "../../modules/sso" 

    account_id = "${data.aws_caller_identity.current.account_id}"
    group_name = "NGLZ_AD_SYNC@microfocusdev.com"
    permissionset_name = "AWSReadOnlyAccess"
}