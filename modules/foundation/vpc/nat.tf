####################################################
# Elastic IPs
####################################################

resource "aws_eip" "nat" {

  for_each = aws_subnet.public

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${each.key}-eip"
    }
  )

}
####################################################
# NAT Gateways
####################################################

resource "aws_nat_gateway" "nat" {

  for_each = aws_subnet.public

  allocation_id = aws_eip.nat[each.key].id

  subnet_id = each.value.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${each.key}-nat"
    }
  )

}
