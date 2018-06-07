resource "aws_db_subnet_group" "mariadb-subnet" {
  name = "mariadb-subnet" #optional
  description = "my maria"
  subnet_ids = ["${aws_subnet.main-private-1.id}", "${aws_subnet.main-private-2.id}"]
  tags = {
    Name = "Maria secure group"
  }
}

resource "aws_db_parameter_group" "mariadb-parameters" {
  name = "mariadb-parameters"
  family = "mariadb10.1"
  description = "mariadb paramerter group"
  parameter {
    name = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "mariadb" {
  allocated_storage = 100
  engine = "mariadb"
  engine_version = "10.1.31"
  instance_class = "db.t2.micro"
  identifier = "mariadb"
  name = "mariadb"
  username = "root"
  password = "${var.RDS_PASSWORD}"
  db_subnet_group_name = "${aws_db_subnet_group.mariadb-subnet.name}"
  parameter_group_name = "${aws_db_parameter_group.mariadb-parameters.name}"
  multi_az = false #set to true to have high availability
  vpc_security_group_ids = ["${aws_security_group.allow-mariadb.id}"] #security group of the db instance
  storage_type = "gp2"
  backup_retention_period = 30
  availability_zone = "${aws_subnet.main-private-1.availability_zone}"#preferred AZ
  skip_final_snapshot =  true #otherwise delete doesn't work
  tags {
    Name = "my-maria"
  }
}

output "rds" {
  value = "${aws_db_instance.mariadb.endpoint}"
}
