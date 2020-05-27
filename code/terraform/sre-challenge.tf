
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



