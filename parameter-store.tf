resource "aws_ssm_parameter" "newrelic_key" {
  name  = "/datadog/${var.tags["Environment"]}/api_key"
  type  = "SecureString"
  value = "example-apikey"

  tags = {
    Environment = "${var.tags["Environment"]}"
    Owner       = var.owner_tag
  }
}