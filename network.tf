resource "aws_vpc" "company_vpc" {
  cidr_block = "172.20.0.0/16"

  tags = {
    Name = "Company VPC"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.company_vpc.id

  tags = {
    Name = "Public Subnet Internet Gateway"
  }
}

resource "aws_eip" "nat_eip" {
  vpc              = true
  depends_on = [aws_internet_gateway.internet_gw]
}


resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.company_vpc.id
  cidr_block        = "172.20.2${count.index}.0/24"
  availability_zone = "${var.default_region}${var.letters_to_zone[count.index]}"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = 3
  vpc_id            = aws_vpc.company_vpc.id
  cidr_block        = "172.20.1${count.index}.0/24"
  availability_zone = "${var.default_region}${var.letters_to_zone[count.index]}"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.private_subnet[0].id

  tags = {
    Name = "Private Subnet Gatewat NAT"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.company_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Public Subnet Route Table"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.company_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "Private Subnet Route Table"
  }

} 

resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route.id
}


resource "aws_security_group" "ec2_app_sg" {
  name        = "EC2 APP SG"
  description = "This SG for APP"
  vpc_id      = aws_vpc.company_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.company_vpc.cidr_block]
    security_groups = [aws_security_group.lb_app_sg.id]
  }

  ingress {
    description = "Non-TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.company_vpc.cidr_block]
    security_groups = [aws_security_group.lb_app_sg.id]
  }

}

resource "aws_security_group" "lb_app_sg" {
  name        = "ALB APP SG"
  description = "This SG for LB APP"
  vpc_id      = aws_vpc.company_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Non-TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}