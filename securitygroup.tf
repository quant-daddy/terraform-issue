resource "aws_security_group" "allow-ssh" {
  vpc_id = "${aws_vpc.main.id}"
  name = "allow-ssh"
  description = "Security group that only allows ssh and all egress traffic"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "allow-ssh"
  }
}

resource "aws_security_group" "access-mariadb" {
  vpc_id = "${aws_vpc.main.id}"
  name = "allow-mariadb-access"
  description = "Security group that only allows access to mariadb instance"
  tags {
    Name = "allow-mariadb-access"
  }
}

resource "aws_security_group" "allow-mariadb" {
  vpc_id = "${aws_vpc.main.id}"
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
