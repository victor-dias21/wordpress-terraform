# wordpress-terraform

Laboratorio Terraform para provisionar WordPress na AWS com EC2, RDS, S3, CloudFront, Route 53 e ACM.

## Objetivo

Construir uma arquitetura WordPress reproduzivel com infraestrutura como codigo, usando modulos oficiais da comunidade `terraform-aws-modules` e validacao automatica no GitHub Actions.

## Arquitetura

```mermaid
flowchart LR
  user[Usuario] --> r53[Route 53]
  r53 --> cf[CloudFront]
  acm[ACM us-east-1] --> cf
  cf --> ec2[EC2 WordPress]
  ec2 --> rds[(RDS MySQL)]
  ec2 --> s3[(S3 assets/backups)]
  ec2 --> sm[Secrets Manager]
  vpc[VPC public/private/database subnets] --- ec2
  vpc --- rds
```

## Recursos

| Camada | Recursos |
| --- | --- |
| Rede | VPC, subnets publicas, privadas e database, NAT Gateway unico para laboratorio |
| Seguranca | Security groups para web e banco, IAM role da instancia |
| Aplicacao | EC2 com Apache, PHP e WordPress via `user_data` |
| Dados | RDS MySQL privado com senha gerenciada pelo Secrets Manager |
| Storage | Bucket S3 privado, versionado e criptografado |
| Borda | CloudFront com certificado ACM e alias no Route 53 |

## Modulos Oficiais

- `terraform-aws-modules/vpc/aws`
- `terraform-aws-modules/security-group/aws`
- `terraform-aws-modules/rds/aws`
- `terraform-aws-modules/s3-bucket/aws`
- `terraform-aws-modules/ec2-instance/aws`
- `terraform-aws-modules/route53/aws`
- `terraform-aws-modules/acm/aws`
- `terraform-aws-modules/cloudfront/aws`

## Como Validar

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

## Como Planejar

1. Copie `terraform.tfvars.example` para `terraform.tfvars`.
2. Ajuste `domain_name`, `hosted_zone_name`, `ami_id` e `ssh_allowed_cidrs`.
3. Autentique na AWS com um perfil de laboratorio.
4. Rode `terraform plan` e revise os custos antes de qualquer apply.

## Cuidados

- Este projeto ainda e um laboratorio, nao uma arquitetura de producao.
- `single_nat_gateway = true` reduz custo, mas nao entrega alta disponibilidade entre AZs.
- A zona Route 53 criada precisa estar delegada no registrador do dominio para ACM e DNS funcionarem.
- O `user_data` prepara o WordPress, mas plugins, hardening e estrategia de deploy ainda devem evoluir.
- Nenhum recurso AWS foi aplicado durante a criacao deste repositório.

## Status

Base funcional de infraestrutura concluida e validada com `terraform validate`.

## Roadmap

- Adicionar backend remoto S3/DynamoDB para state.
- Evoluir para ALB entre CloudFront e EC2.
- Separar modulo reutilizavel para aplicacoes WordPress.
- Adicionar observabilidade com CloudWatch Agent.
- Criar ambiente `dev` e `prod` com workspaces ou estrutura por diretorios.
