locals {
  # generate list of all iam roles; static and from modules
  iam_roles = distinct(concat(
    # static roles from bindings in terraform.tfvars
    keys(var.project_bindings),

    # roles needed by module.zscaler_prod_compute_instances
    module.zscaler_prod_compute_instances.project_iam_roles
  ))


  # merge all bindings for each iam role by checking if a role
  # is a predefined role or a custom role and if it is a custom
  # role, the correct prefix is added to the role path.
  #   eg. projects/${var.project}/roles/custom_role_name
  project_bindings = { for role_name in local.iam_roles :
    length(regexall("roles/", role_name)) > 0 ? role_name :
    format("projects/%s/roles/%s", var.project, role_name) => distinct(concat(
      # static bindings from terraform.tfvars
      lookup(var.project_bindings, role_name, []),

      # bindings needed by module.zscaler_prod_compute_instances
      lookup(module.zscaler_prod_compute_instances.project_bindings, role_name, []),
    ))
  }
}
