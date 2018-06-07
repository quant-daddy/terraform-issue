resource "aws_instance" "example" {
  ami = "${var.AMIS[var.AWS_REGION]}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.main-public-1.id}"
  private_ip = "10.0.1.4" # within the range of main-public-1 subnet cidr block
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}", "${aws_security_group.access-mariadb.id}"]
  key_name = "${aws_key_pair.mykeypair.key_name}"
  user_data = "${data.template_cloudinit_config.cloudinit-example.rendered}"
  tags {
    Name = "Cool kids"
  }
}

resource "aws_eip" "example-eip" {
  instance = "${aws_instance.example.id}"
  vpc = true
}

resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "${aws_instance.example.availability_zone}"
  size = 20
  type = "gp2"
  tags {
    Name = "extra volume data"
  }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "${var.INSTANCE_DEVICE_NAME}"
  volume_id = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id = "${aws_instance.example.id}"
  # Fix for https://github.com/terraform-providers/terraform-provider-aws/issues/2084
  provisioner "remote-exec" {
    when = "destroy"
    inline = "sudo poweroff"
    on_failure = "continue"
    connection {
      type        = "ssh"
      host        = "${aws_instance.example.public_ip}"
      user        = "ubuntu"
      private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
      agent       = false
    }
  }
  # Make sure instance has had some time to power down before attempting volume detachment
  provisioner "local-exec" {
    command = "sleep 30"
    when    = "destroy"
  }
}

output "ip" {
  value = "${aws_instance.example.public_ip}"
}
