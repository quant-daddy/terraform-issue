resource "aws_iam_role" "s3-mybucket-role" {
    name = "s3-mybucket-role"
    # the statement below defines who can assume the role.
    # we only want ec2 instance on aws to assume this role.
    # for details, look: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_manage_modify.html
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "s3-mybucket-role-instanceprofile" {
  name = "s3-mybucket-role"
  role = "${aws_iam_role.s3-mybucket-role.name}"
}

resource "aws_iam_role_policy" "s3-mybucket-role-policy" {
  name = "s3-mybucket-role-policy"
  role = "${aws_iam_role.s3-mybucket-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
            "s3:*"
          ],
          "Resource": [
            "arn:aws:s3:::mybucket-c242312",
            "arn:aws:s3:::mybucket-c242312/*"
          ]
      }
  ]
}
EOF
}

resource "aws_s3_bucket" "b" {
  bucket = "mybucket-c242312"
  acl = "private"
  force_destroy = true
  tags {
    Name = "my-test-bucket"
  }
}
