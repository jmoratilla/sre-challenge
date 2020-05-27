output "Grafana URL" {
  value = "http://${aws_instance.monitor.public_dns}:3000/"
}

output "Etcd URL" {
  value = "http://${aws_elb.etcd_elb.dns_name}:2379/"
}

output "Benchmark SSH" {
  value = "ssh -i ~/.ssh/${var.aws_key_name} admin@${aws_instance.benchmark.public_dns}"
}