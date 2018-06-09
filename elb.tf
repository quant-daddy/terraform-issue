resource "aws_elb" "my-elb" {
  name = "my-elb"
  subnets = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
  security_groups = ["${aws_security_group.elb-securitygroup.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 3
    interval = 30
    timeout = 5
    target = "HTTP:80/"
  }
  # instances = ["${aws_autoscaling_group.example-autoscaling.id}"]
  cross_zone_load_balancing = true #distribute traffic evenly across all targets in the AZ enabled for the elb
  connection_draining = true
  connection_draining_timeout = 400 # for active connections when removing an instance.
  tags {
    Name = "my-elb"
  }
}

output "elb-endpoint" {
  value = "${aws_elb.my-elb.dns_name}"
}
