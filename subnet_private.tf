resource "aws_subnet" "subnet_private" {
  vpc_id = aws_vpc.vpc.id
  count = var.subnet_count
  map_public_ip_on_launch = false
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index+2)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = join("-",["private-subnet"],[element(split("-",data.aws_availability_zones.available.names[count.index]),2)])
  }
}

resource "aws_route_table" "private_route_table" {
  count = var.subnet_count
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.natgw.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count = var.subnet_count
  subnet_id = element(aws_subnet.subnet_private.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}