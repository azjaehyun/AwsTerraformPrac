resource "aws_vpc" "vpc-template" {
  tags = var.tag_name
  cidr_block = var.cidr_block
}
