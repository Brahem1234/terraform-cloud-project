data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

module "network" {
  source              = "../../modules/network"
  name_prefix         = local.name_prefix
  vpc_cidr            = var.vpc_cidr
  azs                 = local.azs
  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
  single_nat_gateway  = var.single_nat_gateway
}

module "storage" {
  source        = "../../modules/storage"
  name_prefix   = local.name_prefix
  force_destroy = var.force_destroy_bucket
}

module "security" {
  source        = "../../modules/security"
  name_prefix   = local.name_prefix
  vpc_id        = module.network.vpc_id
  s3_bucket_arn = module.storage.bucket_arn
}

module "load_balancer" {
  source            = "../../modules/load-balancer"
  name_prefix       = local.name_prefix
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = module.security.alb_sg_id
}

module "compute" {
  source                = "../../modules/compute"
  name_prefix           = local.name_prefix
  subnet_ids            = module.network.app_subnet_ids
  security_group_id     = module.security.app_sg_id
  instance_profile_name = module.security.instance_profile_name
  target_group_arn      = module.load_balancer.target_group_arn
  instance_type         = var.instance_type
  min_size              = var.min_size
  max_size              = var.max_size
  tags                  = local.common_tags
}

module "database" {
  source            = "../../modules/database"
  name_prefix       = local.name_prefix
  subnet_ids        = module.network.db_subnet_ids
  security_group_id = module.security.db_sg_id
  instance_class    = var.db_instance_class
  multi_az          = var.db_multi_az
}