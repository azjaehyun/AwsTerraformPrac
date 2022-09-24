# resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "eip-template" {
  vpc = true
}


# resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
# data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/nat_gateway
resource "aws_nat_gateway" "ngw-template" {
  allocation_id = aws_eip.eip-template.id
  subnet_id     = var.subnet_id
  tags = var.tag_name
}

