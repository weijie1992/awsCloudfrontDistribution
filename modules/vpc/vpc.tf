resource "aws_vpc" "this" {
  cidr_block       = "10.0.1.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "weijie-test"
  }
}
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-southeast-1a"
  cidr_block        = "10.0.1.0/28"
  tags = {
    Name = "pub-subnet-1a"
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-southeast-1b"
  cidr_block        = "10.0.1.16/28"
  tags = {
    Name = "pub-subnet-1b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "weijie-igw"
  }
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "pub1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "pub1b" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.rt.id
}
