# ターゲットグループの設定
resource "aws_alb_target_group" "my_target_group" {
  name = "my-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_target_group"
  }
}

# ALBの設定
resource "aws_alb" "my_alb" {
  name = "my-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.security_group_alb.id]
  subnets = [
    aws_subnet.my_subnet_public_1a.id,
    aws_subnet.my_subnet_public_1c.id
    ]

  tags = {
    Name = "my_alb"
  }
}

# リスナーの設定
resource "aws_alb_listener" "my_listener" {
  load_balancer_arn = aws_alb.my_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.my_target_group.arn
  }
}

# ターゲットグループにEC2を追加
resource "aws_alb_target_group_attachment" "target_group_attachment_ec2" {
  target_group_arn = aws_alb_target_group.my_target_group.arn
  target_id = aws_instance.ec2_web.id
  port = 80
}