resource "aws_instance" "benchmark" {
  ami           = "ami-022a22d06184ceebc"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.my_subnet.id}"
  private_ip    = "172.16.10.30"
  key_name      = "${var.aws_key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_security_group.allow_external_ssh.id}",
    "${aws_security_group.allow_internal_comms.id}"
  ]
  tags = {
    Name = "benchmark"
    Environment = "development"
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir /home/${var.aws_aws_ssh_user}/files",
      "mkdir /home/${var.aws_aws_ssh_user}/ansible",
    ]

    connection {
      type        = "ssh"
      user        = "${var.aws_aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  provisioner "file" {
    source      = "../ansible/benchmark.yml"
    destination = "/home/${var.aws_aws_ssh_user}/ansible/benchmark.yml"

    connection {
      type        = "ssh"
      user        = "${var.aws_aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  provisioner "file" {
    source      = "../benchmark/tests/test.yml"
    destination = "/home/${var.aws_aws_ssh_user}/files/test.yml"

    connection {
      type        = "ssh"
      user        = "${var.aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  # I don't see a need right now here.  Benchmark must be done manually
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get install -y ansible",
  #     "cd ansible; ansible-playbook -c local -i \"localhost,\" benchmark.yml"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "${var.aws_aws_ssh_user}"
  #     private_key = "${file("${var.private_key_path}")}"
  #   }
  # }
}
