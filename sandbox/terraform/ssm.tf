# Create an SSM parameter with a caller ID
resource "aws_ssm_parameter" "sandbox_ssm" {
    name = "/AccountID"
    type = "String"
    value = "${data.aws_caller_identity.current.account_id}"
}