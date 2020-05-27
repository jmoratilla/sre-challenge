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
    Environment = "development"
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
    Environment = "development"
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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "${aws_subnet.my_subnet.cidr_block}" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${aws_subnet.my_subnet.cidr_block}"]
  }

  vpc_id = "${aws_vpc.sre_vpc.id}"

  tags {
    Name = "allow_internal_comms_sg"
    Environment = "development"
  }
}

resource "aws_security_group" "allow_external_ssh" {
  name = "allow_ssh"
  description = "Allow incoming SSH connections."

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
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
    Name = "allow_external_ssh_sg"
    Environment = "development"
  }
}