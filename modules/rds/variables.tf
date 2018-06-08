variable "SUBNET_IDS" {
  type = "list"
  description = <<EOF
  The ids of subnets in which the database would be deployed.
  You need at least two subnets each in a different availability zone.
  The first one would be preferred subnet and the second and later would be
  the failover subnets.
EOF
}

variable "PREFERRED_AZ" {
  description = "The preferred availability zone of the database"
  # "${aws_subnet.main-private-1.availability_zone}"
}
variable "RDS_PASSWORD" {}

variable "VPC_ID" {
  description = "ID of VPC in which the database would be launched"
}
