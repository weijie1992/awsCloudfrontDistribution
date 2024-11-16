resource "aws_security_group" "public_http_https_traffic" {
  description = "Security group allowing traffic on ports 443 and 80"
  name        = "weijie-alb-sg"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "weijie-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.public_http_https_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.public_http_https_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_lb_target_group" "app_front_end" {
  name             = "weijie-tg"
  port             = 3000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "instance"
  vpc_id           = aws_vpc.this.id
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = jsonencode(200)
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}


resource "aws_lb" "alb" {
  name               = "weijie-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_http_https_traffic.id]
  subnets            = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  ssl_policy        = null
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_front_end.arn
    # forward {
    #   stickiness {
    #     duration = 1
    #     enabled  = false
    #   }
    #   target_group {
    #     arn    = "arn:aws:elasticloadbalancing:ap-southeast-1:479833041972:targetgroup/weijie-tg/c73c8023d01227ff"
    #     weight = 1
    #   }
    # }
  }
}
