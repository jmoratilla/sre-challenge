provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_vpc" "sre_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support  = true
  tags = {
    Name = "sre-example"
    Environment = "development"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = "${aws_vpc.sre_vpc.id}"
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "sre-example"
  }
}

resource "aws_internet_gateway" "sre_ig" {
  vpc_id = "${aws_vpc.sre_vpc.id}"
}

resource "aws_route_table" "eu-west-1a-public_rt" {
    vpc_id = "${aws_vpc.sre_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.sre_ig.id}"
    }

    tags {
        Name = "Public Subnet Route Table"
    }
}

resource "aws_route_table_association" "eu-west-1a-public_rta" {
    subnet_id = "${aws_subnet.my_subnet.id}"
    route_table_id = "${aws_route_table.eu-west-1a-public_rt.id}"
}

resource "aws_security_group" "allow_internal_comms" {
    name = "allow_internal_comms"
    description = "Allow incoming connections from subnet"

    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "tcp"
        cidr_blocks = [ "${aws_subnet.my_subnet.cidr_block}" ]
    }
    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "udp"
        cidr_blocks = ["${aws_subnet.my_subnet.cidr_block}"]
    }

    egress {
        from_port = 0
        to_port   = 65535
        protocol  = "tcp"
        cidr_blocks = ["${aws_subnet.my_subnet.cidr_block}"]
    }

    egress {
        from_port = 0
        to_port   = 65535
        protocol  = "udp"
        cidr_blocks = ["${aws_subnet.my_subnet.cidr_block}"]
    }

    vpc_id = "${aws_vpc.sre_vpc.id}"

    tags {
        Name = "allow_internal_comms_sg"
    }
}

resource "aws_security_group" "allow_monitor" {
    name = "allow_monitor"
    description = "Allow incoming HTTP connections to Grafana and Prometheus."

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
    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 65535
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 65535
        protocol  = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.sre_vpc.id}"

    tags {
        Name = "allow_monitor_sg"
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

resource "aws_instance" "monitor" {
  ami           = "ami-022a22d06184ceebc"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.my_subnet.id}"
  private_ip    = "172.16.10.20"
  key_name      = "${var.aws_key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_monitor.id}",
    "${aws_security_group.allow_internal_comms.id}"
  ]

  tags = {
    Name = "monitor"
    Environment = "development"
  }
}

resource "aws_eip" "monitor_eip" {
  instance = "${aws_instance.monitor.id}"
  vpc      = true
  tags = {
    Name = "my-monitor-eip"
    Environment = "development"
  }
}

resource "aws_instance" "benchmark" {
  ami           = "ami-022a22d06184ceebc"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.my_subnet.id}"
  private_ip    = "172.16.10.30"
  key_name      = "${var.aws_key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_internal_comms.id}"
  ]
  tags = {
    Name = "benchmark"
    Environment = "development"
  }
}
