# resource "aws_instance" "example" {
#   ami = "${var.AMIS[var.AWS_REGION]}"
#   instance_type = "t2.micro"
#   subnet_id = "${aws_subnet.main-public-1.id}"
#   private_ip = "10.0.1.4" # within the range of main-public-1 subnet cidr block
#   vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]#, "${module.mariadb-instance.access-security-group-id}"]
#   key_name = "${aws_key_pair.mykeypair.key_name}"
#   user_data = "${data.template_cloudinit_config.cloudinit-example.rendered}"
#   # role:
#   iam_instance_profile = "${aws_iam_instance_profile.s3-mybucket-role-instanceprofile.name}"
#   tags {
#     Name = "Cool kids"
#   }
# }
#
# resource "aws_eip" "example-eip" {
#   instance = "${aws_instance.example.id}"
#   vpc = true
# }


# module "mariadb-instance" {
#   source = "./modules/rds"
#   SUBNET_IDS = ["${aws_subnet.main-private-1.id}", "${aws_subnet.main-private-2.id}"]
#   PREFERRED_AZ = "${aws_subnet.main-private-1.availability_zone}"
#   RDS_PASSWORD = "${var.RDS_PASSWORD}"
#   VPC_ID = "${aws_vpc.main.id}"
# }

# output "db-endpoint" {
#   value = "${module.mariadb-instance.endpoint}"
# }

# output "ip" {
#   value = "${aws_eip.example-eip.public_ip}"
# }
