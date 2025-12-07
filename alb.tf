# Application load balancer (ALB) configuration to distribute incoming HTTP/HTTPS traffic across multiple web servers
# in different availability zones, providing high availability and scalability


# Application load balancer

resource "aws_lb" "main" {
  count = var.enable_alb ? 1 : 0

  name_prefix        = substr(replace(local.project_name, "-", ""), 0, 6) # ALB name limit is 32 chars
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb[0].id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  enable_deletion_protection       = false
  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-alb"
    }
  )
}


# Target group to define where the ALB sends traffic and how to check if instances are healthy.

resource "aws_lb_target_group" "web" {
  count = var.enable_alb ? 1 : 0

  name_prefix = "web-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  # Health check configuration
  health_check {
    healthy_threshold   = 2  # 2 successful checks to be healthy
    unhealthy_threshold = 2  # Unhealthy after 2 failures
    timeout             = 3  # Timeout for health checks
    interval            = 30 # Health check interval
    path                = "/"
    matcher             = "200" # HTTP response code expected
  }

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-tg"
    }
  )

  # Shutdown
  deregistration_delay = 30
}


# Web servers target group for the ALB to send traffic to the EC2 instances 

resource "aws_lb_target_group_attachment" "web_1" {
  count = var.enable_alb ? 1 : 0

  target_group_arn = aws_lb_target_group.web[0].arn
  target_id        = aws_instance.web_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_2" {
  count = var.enable_alb ? 1 : 0

  target_group_arn = aws_lb_target_group.web[0].arn
  target_id        = aws_instance.web_2.id
  port             = 80
}


# ALB listener (HTTP) for incoming traffic 

resource "aws_lb_listener" "http" {
  count = var.enable_alb ? 1 : 0

  load_balancer_arn = aws_lb.main[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web[0].arn
  }
}
