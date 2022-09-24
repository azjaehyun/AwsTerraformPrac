# guide doc
```
https://www.terraform.io/cli/commands/console
```

# variable test
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

# variable test 2
```
resource "random_pet" "example" {
  for_each = var.regions
}
```

# function  - https://www.terraform.io/language/functions
## example - https://www.terraform.io/language/functions/cidrsubnets
```
cidrsubnets("10.1.0.0/16", 4, 4, 8, 4)
```