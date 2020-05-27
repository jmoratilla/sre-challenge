resource "aws_security_group" "allow_etcd" {
    name = "allow_etcd"
    description = "Allow incoming 2379/tcp (etcd) connections to etcd elb."

    ingress {
        from_port = 2379
        to_port = 2379
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.sre_vpc.id}"

    tags {
        Name = "allow_etcd_sg"
    }
}


resource "aws_instance" "etcd1" {
  ami           = "ami-056052088e160e8b3"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.my_subnet.id}"
  private_ip    = "172.16.10.11"
  key_name      = "${var.aws_key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_internal_comms.id}"
  ]
  tags = {
    Name = "etcd1"
    Environment = "development"
    Cluster = "my-etcd-cluster"
  }
}

resource "aws_elb" "etcd_elb" {
  name          = "etcd-elb"
  subnets = ["${aws_subnet.my_subnet.id}"]
  security_groups = [
    "${aws_security_group.allow_etcd.id}"
  ]
  tags = {
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
    target  = "HTTP:2379/metrics/"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  instances = ["${aws_instance.etcd1.id}"]
  tags = {
    Name = "etcd-elb"
    Environment = "development"
  }
}

