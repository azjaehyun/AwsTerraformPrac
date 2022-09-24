variable "regions" {
  type = map(any)
  default = {
    "east" = {
      "region" = "us-east-1",
    },
    "west" = {
      "region" = "eu-west-1",
    },
    "south" = {
      "region" = "ap-south-1",
    },
  }
}

variable "string" {
  type = String
}