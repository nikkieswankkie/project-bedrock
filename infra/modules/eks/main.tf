# infra/modules/eks/main.tf (very condensed)
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnets         = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  vpc_id          = module.vpc.vpc_id
  node_groups = {
    managed_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }
  map_users = [] # we’ll create aws-auth mapping via separate resource or module
}
