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

