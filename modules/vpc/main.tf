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

import {
  to = aws_internet_gateway.igw
  id = "igw-0796f8e6aea089a15"
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "weijie-igw"
  }
}

import {
  to = aws_route_table.rt
  id = "rtb-0f58c2e376a084290"
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

import {
  to = aws_route_table_association.pub1a
  id = "subnet-03b64f004651bbf53/rtb-0f58c2e376a084290"
}

resource "aws_route_table_association" "pub1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.rt.id
}

import {
  to = aws_route_table_association.pub1b
  id = "subnet-0e70486df9027725b/rtb-0f58c2e376a084290"
}

resource "aws_route_table_association" "pub1b" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.rt.id
}
