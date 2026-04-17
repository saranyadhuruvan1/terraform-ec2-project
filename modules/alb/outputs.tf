output "alb_arn" {
  value = aws_lb.this.arn
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}

output "dns_name" {
  value = aws_lb.this.dns_name
}
