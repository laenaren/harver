

variable "vpc_id" {}
variable "alb_sg_id" {}
variable "instance_sg" {}
variable "public_lb_subnet" {}
variable "public_lb_secondary_subnet" {}
variable "instance_id" {}


# Create the Application Load Balancer
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_lb_subnet, var.public_lb_secondary_subnet]

  # In production, I would enable this:
  # enable_deletion_protection = true

  tags = {
    Name = "web_lb"
  }
}

# Create a Target Group
resource "aws_lb_target_group" "web_target_group" {
  name     = "harver-web-instances"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 10
    timeout             = 1
    healthy_threshold   = 1
    unhealthy_threshold = 2
  }

  tags = {
    Name = "web-tg"
  }
}

# Create a Listener for the ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

# Attach EC2 instance to the ALB Target Group
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = var.instance_id
  port             = 80
  depends_on       = [var.instance_id]

}

output "alb_dns" {
  value = aws_lb.web_lb.dns_name
}
