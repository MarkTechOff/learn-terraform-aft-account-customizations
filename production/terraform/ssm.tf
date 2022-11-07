
# Create an SSM paramter indicating this is production
resource "aws_ssm_parameter" "production_ssm" {
    name = "/Workload"
    type = "String"
    value = "PRODUCTION"
}