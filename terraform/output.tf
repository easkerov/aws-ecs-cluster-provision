output "region" {
  value = "${var.region}"
}

output "ecs-load-balancer-name" {
  value = "${aws_alb.ecs-load-balancer.name}"
}

output "ecs-load-balancer-dns-name" {
  value = "${aws_alb.ecs-load-balancer.dns_name}"
}
