output "endpoint" {
  value = "${aws_db_instance.mariadb.endpoint}"
  description = "the endpoint to access the database"
}

output "access-security-group-id" {
  value = "${aws_security_group.access-mariadb.id}"
  description = <<EOF
  the security group id to access the database. Attach this
  to the EC2 instance in the VPC that need access to the database.
EOF
}
