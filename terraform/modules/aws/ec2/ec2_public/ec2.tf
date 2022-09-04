resource "aws_instance" "instance-template" {
  # ami                    = data.aws_ami.ubuntu.id
   ami                    = "ami-0a8b233690bebcb8a" # ami-0a8b233690bebcb8a was # 
  instance_type          = var.instance_type
  vpc_security_group_ids = var.sg_groups
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  tags = var.tag_name
  associate_public_ip_address = var.public_access
}
