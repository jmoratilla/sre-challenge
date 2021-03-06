resource "aws_security_group" "allow_etcd" {
  name = "allow_etcd"
  description = "Allow incoming 2379/tcp (etcd) connections to etcd elb."

  ingress {
    from_port = 2379
    to_port = 2379
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

  tags = {
    Name = "allow_etcd_sg"
    Environment = "development"
  }
}


resource "aws_instance" "etcd" {
  ami           = "ami-0a525e58f7b015153"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.my_subnet.id}"
  private_ip    = "172.16.10.11"
  key_name      = "${var.aws_key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_security_group.allow_external_ssh.id}",
    "${aws_security_group.allow_internal_comms.id}"
  ]
  tags = {
    Name = "etcd1"
    Environment = "development"
    Cluster = "my-etcd-cluster"
  }
    provisioner "remote-exec" {
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
  provisioner "file" {
    source      = "../ansible/etcd.yml"
    destination = "/home/${var.aws_ssh_user}/ansible/etcd.yml"

    connection {
      type        = "ssh"
      user        = "${var.aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }

  provisioner "file" {
    source      = "../etcd/etcd.service"
    destination = "/home/${var.aws_ssh_user}/files/etcd.service"

    connection {
      type        = "ssh"
      user        = "${var.aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd ansible; ansible-playbook -c local -i \"localhost,\" etcd.yml"
    ]

    connection {
      type        = "ssh"
      user        = "${var.aws_ssh_user}"
      private_key = "${file("${var.private_key_path}")}"
    }
  }
  count = 1
}

resource "aws_elb" "etcd_elb" {
  name          = "etcd-elb"
  subnets = ["${aws_subnet.my_subnet.id}"]
  security_groups = [
    "${aws_security_group.allow_etcd.id}"
  ]

  listener {
    instance_port = 2379
    instance_protocol = "http"
    lb_port       = 2379
    lb_protocol   = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 3
    timeout = 3
    target  = "TCP:2379"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  instances = ["${aws_instance.etcd.id}"]
  tags = {
    Name = "etcd-elb"
    Environment = "development"
  }
}

