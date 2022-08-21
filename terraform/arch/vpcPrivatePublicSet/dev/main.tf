# my aws key setting 
provider "aws" {
  region      = var.context.aws_region
  profile     = var.context.aws_profile
  shared_credentials_file = var.context.aws_credentials_file
}

# vpc setting
module "aws_vpc" {
  source     = "../../../modules/aws/vpc"
  cidr_block = "${var.vpc_cidr}.0.0/16"
}


# public subnet setting - [ availability_zone_a ]
module "aws_public_subnet_a" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.11.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = true
  availability_zone = "${var.context.aws_region}a"
}

# public subnet setting - [ availability_zone_c ]
module "aws_public_subnet_c" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.12.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = true
  availability_zone = "${var.context.aws_region}c"
}


# private subnet setting - [ availability_zone_a ]
module "aws_private_subnet_a" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.1.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}a"
}

# private subnet setting - [ availability_zone_c ]
module "aws_private_subnet_c" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.2.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}b"
}

# internet gateway & NAT & subnet Network
module "aws_vpc_network" {
  source    = "../../../modules/aws/network/igw_nat_subnet"
  vpc_id    = module.aws_vpc.vpc_id
  subnet_id = module.aws_public_subnet_a.subnet_id
}


# public route setting - [ internetgateway route table ]
resource "aws_route_table" "public-route" {
  vpc_id = module.aws_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.aws_vpc_network.igw_id
  }

  
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
  name   = "${var.keypair_name}"
}


module "aws_sg" {
  source = "../../../modules/aws/security"
  vpc_id = module.aws_vpc.vpc_id
  name   = "my_sg_group"
}
