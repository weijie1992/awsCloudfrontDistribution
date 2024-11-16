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

# import {
#   to = aws_subnet.public_subnet_1b
#   id = "subnet-005bd47861e9f3eaa"
# }

# resource "aws_subnet" "public_subnet_1b" {
#   availability_zone = "ap-southeast-1b"
#   cidr_block        = "10.0.0.16/28"
#   tags = {
#     Name = "Weijie-pub-1b"
#   }
#   tags_all = {
#     Name = "weijie-pub-1b"
#   }
#   vpc_id = aws_vpc.this.id
# }
