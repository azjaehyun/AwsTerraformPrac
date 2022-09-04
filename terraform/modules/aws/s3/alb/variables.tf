variable "aws_s3_bucket_alb_name" {
  type = string
  #default = "aws_s3_bucket_alb"
}

variable "alb_account_id" {
  type = string
  #default = "aws_s3_bucket_alb"
}


variable "tag_name" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
