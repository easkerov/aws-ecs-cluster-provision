resource "aws_alb" "ecs-load-balancer" {
  name            = "ecs-load-balancer"
  security_groups = ["${aws_security_group.test_public_sg.id}"]
  subnets         = ["${aws_subnet.test_public_sn_01.id}", "${aws_subnet.test_public_sn_02.id}"]

  tags {
    Name = "ecs-load-balancer"
  }
}

resource "aws_alb_target_group" "ecs-target-group" {
  name     = "ecs-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.test_vpc.id}"

  health_check {
    matcher  = "200"          # The HTTP codes to use when checking for a successful response from a target
    path     = "/"            # The destination for the health check request.
    port     = "traffic-port" # The port to use to connect with the target.
    protocol = "HTTP"         # The protocol to use to connect with the target. Defaults to HTTP.
  }

  tags {
    Name = "ecs-target-group"
  }
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = "${aws_alb.ecs-load-balancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
    type             = "forward"
  }
}
