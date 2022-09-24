
# ec2 connect
## resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
## data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair
module "aws_key_pair" {
  source = "../../../../modules/aws/keypair"
  keypair_name   = "${var.keypair_name}"
  tag_name = merge(local.tags, {Name = format("%s-key", local.name_prefix)})
}

# vpc setting
## resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
## data source : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
module "aws_vpc" {
  source     = "../../../../modules/aws/vpc"
  cidr_block = "${var.vpc_cidr}.0.0/16"
  tag_name = merge(local.tags, {Name = format("%s-vpc", local.name_prefix)})
}


