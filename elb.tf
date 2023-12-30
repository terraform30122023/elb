resource "aws_lb" "elb_example" {
  name               = "elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.securitygroup]
  subnets            = [var.subnet_id1,var.subnet_id2]

  enable_deletion_protection = false
    tags = {
    Environment = "elb-example"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.elb_example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.test.arn

    }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  target_type="instance"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = var.instance1
  port             = 80
}
resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = var.instance2
  port             = 80
}


output "elb_example" {
  description = "The DNS name of the ELB"
  value       = aws_lb.elb_example.dns_name
}