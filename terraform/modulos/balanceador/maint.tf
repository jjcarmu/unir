# modulos/balanceador/main.tf
resource "aws_lb" "mean-lb" {
  name               = "mean-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "MEAN LoadBalancer"
  }
}

resource "aws_lb_target_group" "mean-tg" {
  name     = "mean-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "3000"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 20
    interval            = 30
  }

  tags = {
    Name = "MEAN Target Group"
  }
}

resource "aws_lb_listener" "mean-listener" {
  load_balancer_arn = aws_lb.mean-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mean-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "nodejs_instances" {
  count            = length(var.nodejs_instance_ids)
  target_group_arn = aws_lb_target_group.mean-tg.arn
  target_id        = var.nodejs_instance_ids[count.index]
  port             = 3000
}
