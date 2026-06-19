output "alb_dns" {
  value = aws_alb.my_alb.dns_name
}

output "ec2_public_ip_bastion" {
  value = aws_instance.ec2_bastion.public_ip
}
