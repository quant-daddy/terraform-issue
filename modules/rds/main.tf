resource "aws_db_subnet_group" "mariadb-subnet" {
  name = "mariadb-subnet" #optional
  description = "my maria"
  subnet_ids = ["${var.SUBNET_IDS}"]
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

resource "aws_security_group" "access-mariadb" {
  vpc_id = "${var.VPC_ID}"
  name = "allow-mariadb-access"
  description = "Security group that only allows access to mariadb instance"
  tags {
    Name = "allow-mariadb-access"
  }
}

resource "aws_security_group" "allow-mariadb" {
  vpc_id = "${var.VPC_ID}"
  name = "allow-mariadb"
  description = "allow ssh into maria"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${aws_security_group.access-mariadb.id}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "mariadb" {
  allocated_storage = 20
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
  availability_zone = "${var.PREFERRED_AZ}"#preferred AZ
  skip_final_snapshot =  true #otherwise delete doesn't work
  tags {
    Name = "my-maria"
  }
}
