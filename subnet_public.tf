resource "aws_subnet" "subnet_public" {
  vpc_id = aws_vpc.vpc.id
  count = var.subnet_count
  map_public_ip_on_launch = true
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = join("-",["public-subnet"],[element(split("-",data.aws_availability_zones.available.names[count.index]),2)])
  }
}

resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_nat_gateway" "natgw" {
  count = var.subnet_count
  subnet_id = element(aws_subnet.subnet_public.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
  tags = {
    Name = join("-",["nat-gw"],[element(split("-",data.aws_availability_zones.available.names[count.index]),2)])
  }
}