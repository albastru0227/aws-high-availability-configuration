output "alb_dns" {
  value = aws_alb.my_alb.dns_name
}

output "ec2_public_ip_bastion" {
  value = aws_instance.ec2_bastion.public_ip
}

output "ec2_private_ip_web" {
  value = aws_instance.ec2_web.private_ip
}