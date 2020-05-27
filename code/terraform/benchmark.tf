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
}
