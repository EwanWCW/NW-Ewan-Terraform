resource "aws_vpc" "vpc1EW" {
  cidr_block = "91.91.91.0/24"
  tags = {
    "Name" = "natwest-trainer-vpc"
  }
}
resource "aws_subnet" "sn1" {
  vpc_id     = aws_vpc.vpc1EW.id
  cidr_block = "91.91.91.0/25"
  tags = {
    "Name" = "natwest-vpc-s1"
  }
}
resource "aws_subnet" "sn2" {
  vpc_id     = aws_vpc.vpc1EW.id
  cidr_block = "91.91.91.128/25"
  tags = {
    "Name" = "natwest-vpc-s2"
  }
}

resource "aws_route_table" "rtb1" {
  vpc_id = aws_vpc.vpc1EW.id
  tags = {
    "Name" = "Natwest-Route-Table"
  }
}
resource "aws_route_table_association" "rt1-association1" {
  subnet_id      = aws_subnet.sn1.id
  route_table_id = aws_route_table.rtb1.id

}
resource "aws_route_table_association" "rt1-association2" {
  subnet_id      = aws_subnet.sn2.id
  route_table_id = aws_route_table.rtb1.id

}
resource "aws_route" "igroute" {
  # route_table_id            = data.aws_route_table.selected.id
  route_table_id         = aws_route_table.rtb1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw1.id
}

