# my aws key setting 
provider "aws" {
  region      = var.context.aws_region
  profile     = var.context.aws_profile
  # shared_config_files      = ["/Users/tf_user/.aws/conf"]
  shared_credentials_files = [var.context.aws_credentials_file]
}

# vpc setting
module "aws_vpc" {
  source     = "../../../modules/aws/vpc"
  cidr_block = "${var.vpc_cidr}.0.0/16"
  tag_name = merge(local.tags, {Name = format("%s-vpc", local.name_prefix)})
}


# public subnet setting - [ availability_zone_a ] - bastion subnet
module "aws_public_subnet_a" { 
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.11.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = true
  availability_zone = "${var.context.aws_region}a"
  tag_name = merge(local.tags, {Name = format("%s-subnet-public-a", local.name_prefix)})
}

# public subnet setting - [ availability_zone_c ] - 예비 
module "aws_public_subnet_c" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.12.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = true
  availability_zone = "${var.context.aws_region}c"
  tag_name = merge(local.tags, {Name = format("%s-subnet-public-c", local.name_prefix)})
}


# private subnet setting - [ availability_zone_a ] - web 
module "aws_private_subnet_a" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.1.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}a"
  tag_name = merge(local.tags, {Name = format("%s-subnet-private-a", local.name_prefix)})
}

# private subnet setting - [ availability_zone_c ] - web 
module "aws_private_subnet_c" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.2.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}c"
  tag_name = merge(local.tags, {Name = format("%s-subnet-private-c", local.name_prefix)})
}

# internet gateway & NAT & subnet Network
module "aws_vpc_network" {
  source    = "../../../modules/aws/network/igw_nat_subnet"
  vpc_id    = module.aws_vpc.vpc_id
  subnet_id = module.aws_public_subnet_a.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-igw-nat-sunet", local.name_prefix)})
}


# public route setting - [ internetgateway route table ]
resource "aws_route_table" "public-route" {
  vpc_id = module.aws_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.aws_vpc_network.igw_id
  }
  tags = merge(local.tags, {Name = format("%s-public-route", local.name_prefix)})
}

resource "aws_route_table_association" "to-public-a" {
  subnet_id      = module.aws_public_subnet_a.subnet_id
  route_table_id = aws_route_table.public-route.id
}


resource "aws_route_table_association" "to-public-c" {
  subnet_id      = module.aws_public_subnet_c.subnet_id
  route_table_id = aws_route_table.public-route.id
}


# private route setting
resource "aws_route_table" "private-route" {
  vpc_id = module.aws_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.aws_vpc_network.nat_gateway_id
  }
  tags = merge(local.tags, {Name = format("%s-private-route", local.name_prefix)})
}

resource "aws_route_table_association" "to-private-a" {
  subnet_id      = module.aws_private_subnet_a.subnet_id
  route_table_id = aws_route_table.private-route.id
}

resource "aws_route_table_association" "to-private-c" {
  subnet_id      = module.aws_private_subnet_c.subnet_id
  route_table_id = aws_route_table.private-route.id
}

## ec2 connect
module "aws_key_pair" {
  source = "../../../modules/aws/keypair"
  keypair_name   = "${var.keypair_name}"
  tag_name = merge(local.tags, {Name = format("%s-key", local.name_prefix)})
}


module "aws_sg" {
  source = "../../../modules/aws/security/was"
  vpc_id = module.aws_vpc.vpc_id
  tag_name = merge(local.tags, {Name = format("%s-sg", local.name_prefix)})
}

module "aws_ec2_bastion" {
  source        = "../../../modules/aws/ec2/ec2_public"
  sg_groups     = [module.aws_sg.sg_id]
  key_name      = module.aws_key_pair.key_name
  public_access = true
  subnet_id     = module.aws_public_subnet_a.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-ec2", local.name_prefix)})
}

