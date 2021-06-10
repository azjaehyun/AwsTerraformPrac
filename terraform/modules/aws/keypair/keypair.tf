resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = var.name
  public_key = tls_private_key.ssh.public_key_openssh
  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.ssh.private_key_pem}' > ./ec2-key.pem"
  }
}

resource "local_file" "pem_file" {
  filename = pathexpand("./ec2-key.pem")
  file_permission = "600"
  directory_permission = "700"
  sensitive_content = tls_private_key.ssh.private_key_pem
}
