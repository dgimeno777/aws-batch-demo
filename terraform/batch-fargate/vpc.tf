data "aws_subnet" "subnets" {
  for_each = toset(var.subnet_ids)
  id       = each.value
}

data "aws_vpc" "vpc" {
  id = data.aws_subnet.subnets[var.subnet_ids[0]].vpc_id
}
