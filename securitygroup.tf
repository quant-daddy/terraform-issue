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

resource "aws_security_group" "elb-securitygroup" {
  vpc_id = "${aws_vpc.main.id}"
  name = "elb-securitygroup"
  description = "allow http traffic"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-http" {
  vpc_id = "${aws_vpc.main.id}"
  name = "allow-http"
  description = "Security group that allows http:80 from elb and all egress traffic"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb-securitygroup.id}"]
  }
  tags {
    Name = "allow-http"
  }
}
