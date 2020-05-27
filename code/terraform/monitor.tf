
resource "aws_security_group" "allow_monitor" {
  name = "allow_monitor"
  description = "Allow incoming HTTP connections to Grafana and Prometheus."

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.sre_vpc.id}"

  tags {
    Name = "allow_monitor_sg"
    Environment = "development"
  }
}

resource "aws_instance" "monitor" {
  ami           = "ami-022a22d06184ceebc"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.my_subnet.id}"
  private_ip    = "172.16.10.20"
  key_name      = "${var.aws_key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_security_group.allow_monitor.id}",
    "${aws_security_group.allow_internal_comms.id}"
  ]
  tags = {
    Name = "monitor"
    Environment = "development"
  }

  provisioner "remote-exec" "create_files"{
    inline = [
      "mkdir /home/${var.aws_ssh_user}/files",
      "mkdir /home/${var.aws_ssh_user}/ansible",
    ]

    connection {
      type        = "ssh"
      user        = "${var.aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  provisioner "file" "create_monitor"{
    source      = "../ansible/monitor.yml"
    destination = "/home/${var.aws_ssh_user}/ansible/monitor.yml"

    connection {
      type        = "ssh"
      user        = "${var.aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  provisioner "file" "create_dashboard" {
    source      = "../grafana/dashboard.json"
    destination = "/tmp/etcd.json"

    connection {
      type        = "ssh"
      user        = "${var.aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  provisioner "remote-exec" "provision"{
    inline = [
      "sudo apt-get install -y ansible",
      "cd ansible; ansible-playbook -c local -i \"localhost,\" monitor.yml",
    ]

    connection {
      type        = "ssh"
      user        = "${var.aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
}
