resource "aws_route53_zone" "kollate-io" {
  name = "kollate.io"
}

resource "aws_route53_record" "beta-record" {
  zone_id = "${aws_route53_zone.kollate-io.zone_id}"
  name = "beta.kollate.io" # resolves
  type = "A"
  ttl = "300"
  records = ["${aws_eip.example-eip.public_ip}"]
}

resource "aws_route53_record" "www-record" {
  zone_id = "${aws_route53_zone.kollate-io.zone_id}"
  name = "www.kollate.io"
  type = "A"
  ttl = "300"
  records = ["${aws_eip.example-eip.public_ip}"]
}

resource "aws_route53_record" "mail1-record" {
  zone_id = "${aws_route53_zone.kollate-io.zone_id}"
  name = "kollate.io"
  type = "MX"
  ttl = "300"
  # "priority mail_server"
  records = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com",
    "5 alt2.aspmx.l.google.com"
  ]
}

output "ns-servers" {
  value = "${aws_route53_zone.kollate-io.name_servers}"
}
