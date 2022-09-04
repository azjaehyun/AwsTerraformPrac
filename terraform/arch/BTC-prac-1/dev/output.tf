output "aws_ec2_public" {
 value = module.aws_ec2_bastion.public_ip
}

output "private_ip" {
  value = module.aws_ec2_bastion.private_ip
}

output "ssh_private_key_pem" {
  value = module.aws_key_pair.ssh_private_key_pem
  sensitive = true
}

output "ssh_public_key_pem" {
  value = module.aws_key_pair.ssh_public_key_pem
  sensitive = true
}