
resource "aws_vpc" "f5-xc-spoke2" {
  count                = var.spoke2_vpc_enable ? 1 : 0
  cidr_block           = var.spoke2_vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  #enable_classiclink   = "false"

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-vpc"
    Owner = var.resource_owner
  }
}

resource "aws_subnet" "f5-xc-spoke2-external" {
  count                   = var.spoke2_vpc_enable ? 1 : 0
  vpc_id                  = aws_vpc.f5-xc-spoke2.id
  for_each                = var.spoke2_vpc.external
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = "true"
  availability_zone       = var.spoke2_vpc.azs[each.key]["az"]

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-external-${each.key}"
    Owner = var.resource_owner
  }
}

resource "aws_subnet" "f5-xc-spoke2-internal" {
  count                   = var.spoke2_vpc_enable ? 1 : 0
  vpc_id                  = aws_vpc.f5-xc-spoke2.id
  for_each                = var.spoke2_vpc.internal
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = "false"
  availability_zone       = var.spoke2_vpc.azs[each.key]["az"]

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-internal-${each.key}"
    Owner = var.resource_owner
  }
}

resource "aws_subnet" "f5-xc-spoke2-workload" {
  count                   = var.spoke2_vpc_enable ? 1 : 0
  vpc_id                  = aws_vpc.f5-xc-spoke2.id
  for_each                = var.spoke2_vpc.workload
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = "false"
  availability_zone       = var.spoke2_vpc.azs[each.key]["az"]

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-workload-${each.key}"
    Owner = var.resource_owner
  }
}

resource "aws_internet_gateway" "f5-xc-spoke2-vpc-gw" {
  count  = var.spoke2_vpc_enable ? 1 : 0
  vpc_id = aws_vpc.f5-xc-spoke2.id

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-vpc-igw"
    Owner = var.resource_owner
  }
}

resource "aws_route_table" "f5-xc-spoke2-vpc-external-rt" {
  count  = var.spoke2_vpc_enable ? 1 : 0
  vpc_id = aws_vpc.f5-xc-spoke2.id

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-external-rt"
    Owner = var.resource_owner
  }
}

resource "aws_route" "spoke2-internet-rt" {
  count                  = var.spoke2_vpc_enable ? 1 : 0
  route_table_id         = aws_route_table.f5-xc-spoke2-vpc-external-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.f5-xc-spoke2-vpc-gw.id
  depends_on             = [aws_route_table.f5-xc-spoke2-vpc-external-rt]
}

resource "aws_route_table_association" "f5-xc-spoke2-external-association" {
  count          = var.spoke2_vpc_enable ? 1 : 0
  for_each       = aws_subnet.f5-xc-spoke2-external
  subnet_id      = each.value.id
  route_table_id = aws_route_table.f5-xc-spoke2-vpc-external-rt.id
}

resource "aws_eip" "f5-xc-spoke2-nat" {
  count = var.spoke2_vpc_enable ? 1 : 0
  vpc   = true

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-nat-eip"
    Owner = var.resource_owner
  }
}

resource "aws_nat_gateway" "f5-xc-spoke2-vpc-nat" {
  count         = var.spoke2_vpc_enable ? 1 : 0
  allocation_id = aws_eip.f5-xc-spoke2-nat.id
  subnet_id     = aws_subnet.f5-xc-spoke2-external["az1"].id
  depends_on    = [aws_internet_gateway.f5-xc-spoke2-vpc-gw]

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-nat"
    Owner = var.resource_owner
  }
}

resource "aws_route_table" "f5-xc-spoke2-vpc-workload-rt" {
  count  = var.spoke2_vpc_enable ? 1 : 0
  vpc_id = aws_vpc.f5-xc-spoke2.id

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-workload-rt"
    Owner = var.resource_owner
  }
}

resource "aws_route" "spoke2-workload-rt" {
  count                  = var.spoke2_vpc_enable ? 1 : 0
  route_table_id         = aws_route_table.f5-xc-spoke2-vpc-workload-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.f5-xc-spoke2-vpc-nat.id
  depends_on             = [aws_route_table.f5-xc-spoke2-vpc-workload-rt]
}

resource "aws_route_table_association" "f5-xc-spoke2-workload-association" {
  count          = var.spoke2_vpc_enable ? 1 : 0
  for_each       = aws_subnet.f5-xc-spoke2-workload
  subnet_id      = each.value.id
  route_table_id = aws_route_table.f5-xc-spoke2-vpc-workload-rt.id
}

resource "aws_security_group" "f5-xc-spoke2-vpc" {
  count  = var.spoke2_vpc_enable ? 1 : 0
  name   = "${var.project_prefix}-f5-xc-spoke2-sg"
  vpc_id = aws_vpc.f5-xc-spoke2.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["100.64.0.0/10"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.trusted_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.project_prefix}-f5-xc-spoke2-sg"
    Owner = var.resource_owner
  }
}
