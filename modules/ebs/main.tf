

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
      host        = "${aws_eip.example-eip.public_ip}"
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
