# terraform-f5xc-aws-base
# tweak

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.54.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.jumphost](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/instance) | resource |
| [aws_internet_gateway.f5-xc-services-vpc-gw](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/internet_gateway) | resource |
| [aws_network_acl_rule.deny_tcp_53](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.deny_udp_53](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.tcp_53](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.tcp_53-2](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.udp_53](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.udp_53-2](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/network_acl_rule) | resource |
| [aws_route.internet-rt](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/route) | resource |
| [aws_route_table.f5-xc-services-vpc-external-rt](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/route_table) | resource |
| [aws_route_table_association.f5-xc-external-association](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/route_table_association) | resource |
| [aws_security_group.f5-xc-vpc](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/security_group) | resource |
| [aws_subnet.f5-xc-services-external](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/subnet) | resource |
| [aws_subnet.f5-xc-services-internal](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/subnet) | resource |
| [aws_subnet.f5-xc-services-workload](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/subnet) | resource |
| [aws_vpc.f5-xc-services](https://registry.terraform.io/providers/hashicorp/aws/4.54.0/docs/resources/vpc) | resource |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/3.2.1/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_trust_localip"></a> [auto\_trust\_localip](#input\_auto\_trust\_localip) | if true, query ifconfig.io for public ip of terraform host. | `bool` | `false` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | aws region | `string` | n/a | yes |
| <a name="input_create_jumphost"></a> [create\_jumphost](#input\_create\_jumphost) | Create a jumphost for troubleshooting purposes (true or false) | `bool` | n/a | yes |
| <a name="input_project_prefix"></a> [project\_prefix](#input\_project\_prefix) | projectPrefix name for tagging | `string` | n/a | yes |
| <a name="input_resource_owner"></a> [resource\_owner](#input\_resource\_owner) | Owner of the deployment for tagging purposes | `string` | n/a | yes |
| <a name="input_services_vpc"></a> [services\_vpc](#input\_services\_vpc) | Services VPC | `map(any)` | n/a | yes |
| <a name="input_services_vpc_cidr_block"></a> [services\_vpc\_cidr\_block](#input\_services\_vpc\_cidr\_block) | n/a | `string` | n/a | yes |
| <a name="input_trusted_ip"></a> [trusted\_ip](#input\_trusted\_ip) | IP to allow external access | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_az1"></a> [aws\_az1](#output\_aws\_az1) | n/a |
| <a name="output_aws_az2"></a> [aws\_az2](#output\_aws\_az2) | n/a |
| <a name="output_aws_az3"></a> [aws\_az3](#output\_aws\_az3) | n/a |
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | n/a |
| <a name="output_external_subnets"></a> [external\_subnets](#output\_external\_subnets) | n/a |
| <a name="output_internal_subnets"></a> [internal\_subnets](#output\_internal\_subnets) | n/a |
| <a name="output_jumphost_spoke1_public_ip"></a> [jumphost\_spoke1\_public\_ip](#output\_jumphost\_spoke1\_public\_ip) | Public IP address of jumphost in spoke 1 |
| <a name="output_project_prefix"></a> [project\_prefix](#output\_project\_prefix) | n/a |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | n/a |
| <a name="output_service_cidr_block"></a> [service\_cidr\_block](#output\_service\_cidr\_block) | n/a |
| <a name="output_service_external_route_table"></a> [service\_external\_route\_table](#output\_service\_external\_route\_table) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_workload_subnets"></a> [workload\_subnets](#output\_workload\_subnets) | n/a |
<!-- END_TF_DOCS -->