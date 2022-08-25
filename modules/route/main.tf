resource "aws_route" "this" {
  route_table_id         = var.route_table_this.id
  gateway_id             = var.igw_this == null ? null : var.igw_this.id
  nat_gateway_id         = var.nat_gateway_this == null ? null : var.nat_gateway_this.id
  destination_cidr_block = var.destination_cidr_block
}
