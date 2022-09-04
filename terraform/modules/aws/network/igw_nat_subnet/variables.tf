variable "tag_name" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}
