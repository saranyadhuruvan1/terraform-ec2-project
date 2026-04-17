resource "aws_lb_target_group" "this" {
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = var.health_check_path
    protocol            = var.protocol
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}