resource "aws_sns_topic" "example-sns" {
  name = "sg-sns"
  display_name = "example ASG SNS topic"
}
