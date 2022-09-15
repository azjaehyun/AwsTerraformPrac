output "private_ip" {
  value = aws_instance.instance-template.private_ip
}

output "ec2_id" {
  value = aws_instance.instance-template.id
}