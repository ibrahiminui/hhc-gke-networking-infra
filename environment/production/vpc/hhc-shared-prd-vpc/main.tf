/**

locals {
  data_dirs = [
    "subnets",
    "firewall_rules",

  ]

  loaded_data = {
    for dir in local.data_dirs :
    dir => flatten([
      for file in fileset("${path.module}/${dir}", "*.json") :
      [jsondecode(file("${path.module}/${dir}/${file}"))]
    ])
  }

  subnets        = local.loaded_data["subnets"]
  firewall_rules = local.loaded_data["firewall_rules"]
}

module "vpc" {
  source = "../../../../modules/vpc-network"

  name       = var.vpc
  project_id = var.project_id

  subnets        = local.subnets
  firewall_rules = local.firewall_rules
}
**/