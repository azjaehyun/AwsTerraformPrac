## guide doc
```
https://www.terraform.io/cli/commands/console
```

## variable test
```
$ echo 'split(",", "foo,bar,baz")' | terraform console
tolist([
  "foo",
  "bar",
  "baz",
])

or

terraform console
> split(",", "foo,bar,baz")
tolist([
  "foo",
  "bar",
  "baz",
])
```

## variable test 2
```
resource "random_pet" "example" {
  for_each = var.regions
}
```

## function  - https://www.terraform.io/language/functions
### example - https://www.terraform.io/language/functions/cidrsubnets
```
terraform console
>cidrsubnets("10.1.0.0/16", 4, 4, 8, 4)
>tolist([
  "10.1.0.0/20",
  "10.1.16.0/20",
  "10.1.32.0/24",
  "10.1.48.0/20",
])
>cidrsubnets("10.1.0.0/16", 8, 8, 8, 8)
tolist([
  "10.1.0.0/24",
  "10.1.1.0/24",
  "10.1.2.0/24",
  "10.1.3.0/24",
])
>cidrsubnets("10.1.0.0/16", 8, 8)
tolist([
  "10.1.0.0/24",
  "10.1.1.0/24",
])
```