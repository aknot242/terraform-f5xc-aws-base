
resource "aws_vpc" "f5-xc-services" {
  cidr_block           = var.services_vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  #enable_classiclink   = "false"

  tags = {
    Name  = "${var.project_prefix}-f5-xc-services-vpc"
    Owner = var.resource_owner
  }
}

locals {

}

resource "aws_subnet" "f5-xc-services-external" {
  vpc_id                  = aws_vpc.f5-xc-services.id
  for_each                = var.services_vpc.external
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = "true"
  availability_zone       = var.services_vpc.azs[each.key]["az"]

  tags = {
    Name  = "${var.project_prefix}-f5-xc-services-external-${each.key}"
    Owner = var.resource_owner
  }
}

resource "aws_subnet" "f5-xc-services-internal" {
  vpc_id                  = aws_vpc.f5-xc-services.id
  for_each                = var.services_vpc.internal
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = "false"
  availability_zone       = var.services_vpc.azs[each.key]["az"]

  tags = {
    Name  = "${var.project_prefix}-f5-xc-services-internal-${each.key}"
    Owner = var.resource_owner
  }
}

resource "aws_subnet" "f5-xc-services-workload" {
  vpc_id                  = aws_vpc.f5-xc-services.id
  for_each                = var.services_vpc.workload
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = "false"
  availability_zone       = var.services_vpc.azs[each.key]["az"]

  tags = {
    Name  = "${var.project_prefix}-f5-xc-services-workload-${each.key}"
    Owner = var.resource_owner
  }
}

resource "aws_internet_gateway" "f5-xc-services-vpc-gw" {
  vpc_id = aws_vpc.f5-xc-services.id

  tags = {
    Name  = "${var.project_prefix}-f5-xc-services-vpc-igw"
    Owner = var.resource_owner
  }
}

resource "aws_route_table" "f5-xc-services-vpc-external-rt" {
  vpc_id = aws_vpc.f5-xc-services.id

  tags = {
    Name  = "${var.project_prefix}-f5-xc-services-external-rt"
    Owner = var.resource_owner
  }
}

resource "aws_route" "internet-rt" {
  route_table_id         = aws_route_table.f5-xc-services-vpc-external-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.f5-xc-services-vpc-gw.id
  depends_on             = [aws_route_table.f5-xc-services-vpc-external-rt]
}

resource "aws_route_table_association" "f5-xc-external-association" {
  for_each       = aws_subnet.f5-xc-services-external
  subnet_id      = each.value.id
  route_table_id = aws_route_table.f5-xc-services-vpc-external-rt.id
}

resource "aws_security_group" "f5-xc-vpc" {
  name   = "${var.project_prefix}-f5-xc-sg"
  vpc_id = aws_vpc.f5-xc-services.id

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
    Name  = "${var.project_prefix}-f5-xc-sg"
    Owner = var.resource_owner
  }
}

resource "aws_network_acl_rule" "tcp_53" {
  network_acl_id = aws_vpc.f5-xc-services.default_network_acl_id
  rule_number    = 90
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "100.64.0.0/10"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "udp_53" {
  network_acl_id = aws_vpc.f5-xc-services.default_network_acl_id
  rule_number    = 91
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "100.64.0.0/10"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "tcp_53-2" {
  network_acl_id = aws_vpc.f5-xc-services.default_network_acl_id
  rule_number    = 92
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "192.168.0.0/16"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "udp_53-2" {
  network_acl_id = aws_vpc.f5-xc-services.default_network_acl_id
  rule_number    = 93
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "192.168.0.0/16"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "deny_tcp_53" {
  network_acl_id = aws_vpc.f5-xc-services.default_network_acl_id
  rule_number    = 98
  egress         = false
  protocol       = "tcp"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "deny_udp_53" {
  network_acl_id = aws_vpc.f5-xc-services.default_network_acl_id
  rule_number    = 99
  egress         = false
  protocol       = "udp"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}
