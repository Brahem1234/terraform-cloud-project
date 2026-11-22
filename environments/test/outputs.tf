output "alb_url" { value = "http://${module.load_balancer.alb_dns_name}" }
output "asg_name" { value = module.compute.asg_name }
output "db_endpoint" { value = module.database.db_endpoint }
output "bucket_name" { value = module.storage.bucket_name }
output "vpc_id" { value = module.network.vpc_id }