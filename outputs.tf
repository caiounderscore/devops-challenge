output "private-key" {
  value = "${tls_private_key.default-private-key.private_key_pem}"
}

output "loa-balancer-endpoint" {
  value = "${aws_alb.alb.dns_name}"
}
