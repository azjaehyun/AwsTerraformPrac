# my aws key setting 
provider "aws" {
  region      = var.context.aws_region
  profile     = var.context.aws_profile
  # shared_config_files      = ["/Users/tf_user/.aws/conf"]
  shared_credentials_files = [var.context.aws_credentials_file]
}

## ec2 connect
module "aws_key_pair" {
  source = "../../../modules/aws/keypair"
  keypair_name   = "${var.keypair_name}"
  tag_name = merge(local.tags, {Name = format("%s-key", local.name_prefix)})
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


# private subnet setting - [ availability_zone_a ] - web1
module "aws_private_subnet_web_a" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.1.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}a"
  tag_name = merge(local.tags, {Name = format("%s-subnet-private-web-a", local.name_prefix)})
}

# private subnet setting - [ availability_zone_c ] - web2
module "aws_private_subnet_web_c" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.2.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}c"
  tag_name = merge(local.tags, {Name = format("%s-subnet-private-web-c", local.name_prefix)})
}

# private subnet setting - [ availability_zone_a ] - was1
module "aws_private_subnet_was_a" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.3.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}a"
  tag_name = merge(local.tags, {Name = format("%s-subnet-private-was-a", local.name_prefix)})
}

# private subnet setting - [ availability_zone_c ] - was2
module "aws_private_subnet_was_c" {
  source     = "../../../modules/aws/subnet"
  cidr_block = "${var.vpc_cidr}.4.0/24"
  vpc_id     = module.aws_vpc.vpc_id
  is_public  = false
  availability_zone = "${var.context.aws_region}c"
  tag_name = merge(local.tags, {Name = format("%s-subnet-private-was-c", local.name_prefix)})
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

resource "aws_route_table_association" "to-private-web-a" {
  subnet_id      = module.aws_private_subnet_web_a.subnet_id
  route_table_id = aws_route_table.private-route.id
}

resource "aws_route_table_association" "to-private-web-c" {
  subnet_id      = module.aws_private_subnet_web_c.subnet_id
  route_table_id = aws_route_table.private-route.id
}

resource "aws_route_table_association" "to-private-was-a" {
  subnet_id      = module.aws_private_subnet_was_a.subnet_id
  route_table_id = aws_route_table.private-route.id
}

resource "aws_route_table_association" "to-private-was-c" {
  subnet_id      = module.aws_private_subnet_was_c.subnet_id
  route_table_id = aws_route_table.private-route.id
}

module "aws_sg_default" {
  source = "../../../modules/aws/security"
  vpc_id = module.aws_vpc.vpc_id
  name =  format("%s-sg-ssh-default", local.name_prefix)
  tag_name = merge(local.tags, {Name = format("%s-sg-default", local.name_prefix)})
}

module "aws_sg_web" {
  source = "../../../modules/aws/security/web"
  vpc_id = module.aws_vpc.vpc_id
  name =  format("%s-sg-22-80", local.name_prefix)
  tag_name = merge(local.tags, {Name = format("%s-sg-web", local.name_prefix)})
}

module "aws_sg_was" {
  source = "../../../modules/aws/security/was"
  vpc_id = module.aws_vpc.vpc_id
  name =  format("%s-sg-22-8080", local.name_prefix)
  tag_name = merge(local.tags, {Name = format("%s-sg-was", local.name_prefix)})
}

module "aws_ec2_bastion" {
  source        = "../../../modules/aws/ec2/ec2_public"
  sg_groups     = [module.aws_sg_default.sg_id]
  key_name      = module.aws_key_pair.key_name
  public_access = true
  subnet_id     = module.aws_public_subnet_a.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-ec2-public-bastion-a", local.name_prefix)})
}

module "private-web-a" {
  source        = "../../../modules/aws/ec2/ec2_private"
  sg_groups     = [module.aws_sg_web.sg_id]
  key_name      = module.aws_key_pair.key_name
  subnet_id     = module.aws_private_subnet_web_a.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-ec2-private-web-a", local.name_prefix)})
}


module "private-web-c" {
  source        = "../../../modules/aws/ec2/ec2_private"
  sg_groups     = [module.aws_sg_web.sg_id]
  key_name      = module.aws_key_pair.key_name
  subnet_id     = module.aws_private_subnet_web_c.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-ec2-private-web-c", local.name_prefix)})
}


module "private-was-a" {
  source        = "../../../modules/aws/ec2/ec2_private"
  sg_groups     = [module.aws_sg_was.sg_id]
  key_name      = module.aws_key_pair.key_name
  subnet_id     = module.aws_private_subnet_was_a.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-ec2-private-was-a", local.name_prefix)})
}

module "private-was-c" {
  source        = "../../../modules/aws/ec2/ec2_private"
  sg_groups     = [module.aws_sg_web.sg_id]
  key_name      = module.aws_key_pair.key_name
  subnet_id     = module.aws_private_subnet_was_c.subnet_id
  tag_name = merge(local.tags, {Name = format("%s-ec2-private-was-b", local.name_prefix)})
}

## alb area 
# ALB
module "aws-lb-web-alb" {
    source             = "../../../modules/aws/loadbalancer"
    lb_name = format("%s-web-alb", local.name_prefix)
    lb_internal           = false
    lb_type = "application"
    security_groups    = [module.aws_sg_web.sg_id]
    subnets            = [module.aws_public_subnet_a.subnet_id, module.aws_public_subnet_c.subnet_id]
    tag_name = merge(local.tags, {Name = format("%s-web-alb", local.name_prefix)})
    
    #target group setting
    lb_target_group_name = format("%s-web-alb-tg", local.name_prefix)
    vpc_id = module.aws_vpc.vpc_id
    lb_protocol = "HTTP"
    tg_tag_name = merge(local.tags, {Name = format("%s-web-tg", local.name_prefix)})

    #lb_attachment setting - ec2 연결 
    nlb_listeners_ids = [ module.private-web-a.ec2_id , module.private-web-c.ec2_id ]
    target_port = 80
}



resource "aws_lb_target_group_attachment" "web-alb-tg-att-web1" {
    target_group_arn = module.aws-lb-web-alb.lb-tg-arn
    target_id = module.private-web-a.ec2_id
    port = 80
}

resource "aws_lb_target_group_attachment" "web-alb-tg-att-web2" {
    target_group_arn = module.aws-lb-web-alb.lb-tg-arn
    target_id = module.private-web-c.ec2_id
    port = 80
}


# Launch Configuration
resource "aws_launch_configuration" "awsome-ap2-web-conf" {
    name_prefix     = "awsome-ap2-web-"
    image_id        = "ami-0e7d2dd1aca45ce5c"
    instance_type   = "t2.micro"
    user_data       = <<EOF
#!/bin/bash
sudo su
source /etc/profile
cd /mnt/efs/apache/bin/
./apachectl start
EOF
    security_groups = [module.aws_sg_web.sg_id]
    lifecycle {
        create_before_destroy = true
    }
}

# Auto Scaling group
resource "aws_autoscaling_group" "awsome-ap2-web-as" {
    min_size             = 2
    max_size             = 4
    desired_capacity     = 2
    launch_configuration = aws_launch_configuration.awsome-ap2-web-conf.name
    vpc_zone_identifier  = [module.aws_public_subnet_a.subnet_id, module.aws_public_subnet_c.subnet_id]
}
