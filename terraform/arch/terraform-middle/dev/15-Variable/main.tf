resource "random_pet" "example" {
  for_each = var.regions
}