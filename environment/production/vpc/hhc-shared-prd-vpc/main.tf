locals {
  data_dirs = [
    "subnets",
    "firewall_rules",
    "vpc_peerings",
    "global_addresses",
    "service_peerings",
    "routes",
    "vpc_access_connectors",
    "service_connection_policies"
  ]

  loaded_data = {
    for dir in local.data_dirs :
    dir => flatten([
      for file in fileset("${path.module}/${dir}", "*.json") :
      [jsondecode(file("${path.module}/${dir}/${file}"))]
    ])
  }

  subnets                     = local.loaded_data["subnets"]
  firewall_rules              = local.loaded_data["firewall_rules"]
  vpc_peerings                = local.loaded_data["vpc_peerings"]
  global_addresses            = local.loaded_data["global_addresses"]
  service_peerings            = local.loaded_data["service_peerings"]
  routes                      = local.loaded_data["routes"]
  vpc_access_connectors       = local.loaded_data["vpc_access_connectors"]
  service_connection_policies = local.loaded_data["service_connection_policies"]
}

module "vpc" {
  #checkov:skip=CKV_TF_1: Using a local module
  source = "../../../../modules/vpc-network"

  name = var.vpc

  subnets                     = local.subnets
  subnet_iam_admin_role       = var.subnet_iam_admin_role
  firewall_rules              = local.firewall_rules
  vpc_peerings                = local.vpc_peerings
  global_addresses            = local.global_addresses
  service_peerings            = local.service_peerings
  routes                      = local.routes
  vpc_access_connectors       = local.vpc_access_connectors
  service_connection_policies = local.service_connection_policies
}
