resource "aws_internet_gateway" "gw1" {
  vpc_id = aws_vpc.vpc1EW.id
  tags = {
    Name = "IG-Natwest"
  }
}
