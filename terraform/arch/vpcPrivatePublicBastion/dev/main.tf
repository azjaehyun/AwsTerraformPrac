# my aws key setting 
provider "aws" {
  region      = var.context.aws_region
  profile     = var.context.aws_profile
  # shared_config_files      = ["/Users/tf_user/.aws/conf"]
  shared_credentials_files = [var.context.aws_credentials_file]
}

# vpc setting
module "s3" {
  source     = "../../../modules/aws/s3/alb"
  aws_s3_bucket_alb_name = "alb-log-example.com"
  tag_name = merge(local.tags, {Name = format("%s-vpc", local.name_prefix)})
  alb_account_id = var.context.aws_profile
}
