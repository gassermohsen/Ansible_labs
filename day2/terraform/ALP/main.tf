rresource "aws_security_group" "ALP_sg" {
  name        = "Application-loadBalancer-1"
  description = "Application load balancer for public ec2"
  vpc_id      = var.vpc_id

 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
}

resource "aws_lb" "ansible_lb" {
  name               = "ansible-ALP"
  internal           = false
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.ALP_sg.id ]
  subnets            = var.public_subnet_ids 
  tags = {
    Name = "ansible-lb"
  }
}

resource "aws_lb_target_group" "ansible_tg" {
  name     = "targetGroup1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    Name = "ansible_tg"
  }
}

resource "aws_lb_target_group_attachment" "attach-priv1" {
  target_group_arn = aws_lb_target_group.ansible_tg.arn
  target_id        = var.private-nexus
  port             = 8081
}

resource "aws_lb_target_group_attachment" "attach-priv2" {
  target_group_arn = aws_lb_target_group.ansible_tg.arn
  target_id        = var.private-sonarQube
  port             = 9000
}

resource "aws_lb_listener" "listener1" {
  load_balancer_arn = aws_lb.ansible_lb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ansible_tg.arn
  }
}









