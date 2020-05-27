provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_vpc" "sre_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "sre-example"
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

resource "aws_network_interface" "foo" {
  subnet_id   = "${aws_subnet.my_subnet.id}"
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "etcd1" {
  ami           = "ami-098267ef3a68ff186"
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = "${aws_network_interface.foo.id}"
    device_index         = 0
  }
  tags = {
    Name = "etcd1"
    Environment = "development"
    Cluster = "my-etcd-cluster"
  }
}

resource "aws_instance" "monitor" {
  ami           = "ami-022a22d06184ceebc"
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = "${aws_network_interface.foo.id}"
    device_index         = 0
  }
  tags = {
    Name = "monitor"
    Environment = "development"
  }
}

resource "aws_instance" "benchmark" {
  ami           = "ami-022a22d06184ceebc"
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = "${aws_network_interface.foo.id}"
    device_index         = 0
  }
  tags = {
    Name = "benchmark"
    Environment = "development"
  }
}
