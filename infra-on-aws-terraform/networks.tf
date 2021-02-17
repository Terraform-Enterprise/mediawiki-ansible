resource "aws_vpc" "mediwiki_vpc" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "mediwiki_vpc"
  }
}
resource "aws_subnet" "mediwiki_Private_subnet1" {
  vpc_id     = aws_vpc.mediwiki_vpc.id
  availability_zone = "us-west-1b"
  cidr_block = "10.0.0.0/26"

  tags = {
    Name = "mediwiki_Private_subnet1"
  }
}
resource "aws_subnet" "mediwiki_Private_subnet2" {
  vpc_id     = aws_vpc.mediwiki_vpc.id
  availability_zone = "us-west-1c"
  cidr_block = "10.0.0.64/26"

  tags = {
    Name = "mediwiki_Private_subnet2"
  }
}
resource "aws_subnet" "mediwiki_Public_subnet1" {
  vpc_id     = aws_vpc.mediwiki_vpc.id
  availability_zone = "us-west-1c"
  cidr_block = "10.0.0.128/26"

  tags = {
    Name = "mediwiki_Public_subnet1"
  }
}
resource "aws_subnet" "mediwiki_Public_subnet2" {
  vpc_id     = aws_vpc.mediwiki_vpc.id
  availability_zone = "us-west-1b"
  cidr_block = "10.0.0.192/26"

  tags = {
    Name = "mediwiki_Public_subnet2"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mediwiki_vpc.id
  tags = {
    Name = "mediwiki_igw"
}
}
resource "aws_route_table" "mediawiki_public_rt1" {
  vpc_id = aws_vpc.mediwiki_vpc.id
  tags = {
    Name = "mediawiki_public_rt1"
    }
}

resource "aws_route" "default_public" {
  route_table_id         = aws_route_table.mediawiki_public_rt1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.mediwiki_Public_subnet1.id
  route_table_id = aws_route_table.mediawiki_public_rt1.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.mediwiki_Public_subnet2.id
  route_table_id = aws_route_table.mediawiki_public_rt1.id
}
resource "aws_eip" "eip" {
  tags = {
    Name = "mediawiki-natgw-ip"
    }
}
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.mediwiki_Public_subnet1.id

  tags = {
    Name = "mediawiki-NAT"
  }
}
resource "aws_route_table" "mediawiki_private_rt1" {
  vpc_id = aws_vpc.mediwiki_vpc.id
  tags = {
    Name = "mediawiki_private_rt1"
    }
}
resource "aws_route" "default_private" {
  route_table_id         = aws_route_table.mediawiki_private_rt1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id    = aws_nat_gateway.ngw.id
}
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.mediwiki_Private_subnet1.id
  route_table_id = aws_route_table.mediawiki_private_rt1.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.mediwiki_Private_subnet2.id
  route_table_id = aws_route_table.mediawiki_private_rt1.id
}