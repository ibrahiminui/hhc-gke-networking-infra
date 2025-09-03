output "dns" {
  description = "The DNS zone details."
  value       = module.dns
}
output "wug02-nonprod-ips" {
  description = "The egress IP addresses for US-Central1 non prod."
  value       = module.nonprod.wug02_external_ips
}

output "wug02-prod-ips" {
  description = "The egress IP addresses for US-Central1 prod."
  value       = module.prod.wug02_external_ips
}

output "cug01-nonprod-ips" {
  description = "The egress IP addresses for US-Central1 non prod."
  value       = module.nonprod.cug01_external_ips
}

output "cug01-prod-ips" {
  description = "The egress IP addresses for US-Central1 prod."
  value       = module.prod.cug01_external_ips
}

output "wug02-ssnonprod-ips" {
  description = "The egress IP addresses for Shared Services VPC."
  value       = module.ssnonprod.wug02_external_ips
}

output "cug01-ssnonprod-ips" {
  description = "The egress IP addresses for Shared Services VPC."
  value       = module.ssnonprod.cug01_external_ips
}

output "wug02-ssprod-ips" {
  description = "The egress IP addresses for Shared Services VPC."
  value       = module.ssprod.wug02_external_ips
}

output "cug01-ssprod-ips" {
  description = "The egress IP addresses for Shared Services VPC."
  value       = module.ssprod.cug01_external_ips
}
