import {
  to = aws_vpc.this
  id = "vpc-003f6fd17cc777a78"
}

resource "aws_vpc" "this" {
  cidr_block       = "10.0.1.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "weijie-test"
  }
}

import {
  to = aws_subnet.public_subnet_1a
  id = "subnet-03b64f004651bbf53"
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-southeast-1a"
  cidr_block        = "10.0.1.0/28"
  tags = {
    Name = "pub-subnet-1a"
  }
}
import {
  to = aws_subnet.public_subnet_1b
  id = "subnet-0e70486df9027725b"
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.this.id
  availability_zone = "ap-southeast-1b"
  cidr_block        = "10.0.1.16/28"
  tags = {
    Name = "pub-subnet-1b"
  }
}
