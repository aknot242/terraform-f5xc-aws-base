output "project_prefix" {
  value = var.project_prefix
}

output "aws_region" {
  value = var.aws_region
}

output "aws_az1" {
  value = var.services_vpc.azs["az1"]["az"]
}
output "aws_az2" {
  value = var.services_vpc.azs["az2"]["az"]
}

output "aws_az3" {
  value = var.services_vpc.azs["az3"]["az"]
}

output "external_subnets" {
  value = aws_subnet.f5-xc-services-external
}

output "internal_subnets" {
  value = aws_subnet.f5-xc-services-internal
}

output "workload_subnets" {
  value = aws_subnet.f5-xc-services-workload
}

output "security_group" {
  value = aws_security_group.f5-xc-vpc.id
}

output "vpc_id" {
  value = aws_vpc.f5-xc-services.id
}

output "service_external_route_table" {
  value = aws_route_table.f5-xc-services-vpc-external-rt.id
}

output "service_cidr_block" {
  value = var.services_vpc_cidr_block
}
