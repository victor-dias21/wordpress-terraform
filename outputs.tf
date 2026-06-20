output "name_prefix" {
  description = "Prefixo comum usado nos recursos."
  value       = local.name_prefix
}

output "vpc_id" {
  description = "ID da VPC criada para o WordPress."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Subnets publicas usadas pela camada web."
  value       = module.vpc.public_subnets
}

output "database_subnet_ids" {
  description = "Subnets privadas usadas pelo RDS."
  value       = module.vpc.database_subnets
}

output "database_endpoint" {
  description = "Endpoint do RDS MySQL."
  value       = module.wordpress_database.db_instance_endpoint
}

output "wordpress_bucket_name" {
  description = "Nome do bucket S3 privado do WordPress."
  value       = module.wordpress_bucket.s3_bucket_id
}

output "database_secret_arn" {
  description = "ARN do secret gerenciado pelo RDS para o usuario master."
  value       = module.wordpress_database.db_instance_master_user_secret_arn
}

output "wordpress_instance_id" {
  description = "ID da instancia EC2 do WordPress."
  value       = module.wordpress_instance.id
}

output "wordpress_public_dns" {
  description = "DNS publico da instancia WordPress."
  value       = module.wordpress_instance.public_dns
}

output "cloudfront_domain_name" {
  description = "Dominio gerado pelo CloudFront."
  value       = module.wordpress_cdn.cloudfront_distribution_domain_name
}

output "route53_zone_id" {
  description = "ID da zona publica criada no Route 53."
  value       = module.wordpress_dns.id
}
