
# Create an SSM paramter indicating this is Sandbox
resource "aws_ssm_parameter" "production_ssm" {
    name = "/Workload"
    type = "String"
    value = "SANDBOX"
}