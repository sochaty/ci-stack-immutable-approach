
data "aws_subnets" "private-subnets" {
  filter {
    name   = "tag:Name"
    values = ["Private-Subnet-*"]
  }
  depends_on = [aws_subnet.private-subnet]
}

data "aws_subnets" "public-subnets" {
  filter {
    name   = "tag:Name"
    values = ["Public-Subnet-*"]
  }
  depends_on = [aws_subnet.public-subnet]
}

resource "aws_subnet" "public-subnet" {
  count = length(var.public_subnet_cidr)

  cidr_block        = var.public_subnet_cidr[count.index]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}${var.zones[count.index]}"

  tags = {
    Name = "Public-Subnet-${count.index}"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "private-subnet" {
  count = length(var.private_subnet_cidr)

  cidr_block        = var.private_subnet_cidr[count.index]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}${var.zones[count.index]}"

  tags = {
    Name = "Private-Subnet-${count.index}"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}