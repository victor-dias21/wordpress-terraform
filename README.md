# wordpress-terraform

Projeto Codex para planejar uma infraestrutura Terraform para WordPress.

## Objetivo

Construir, de forma incremental, um laboratorio de infraestrutura como codigo para hospedar WordPress com foco em automacao, seguranca basica, persistencia e operacao simples.

## Ideias iniciais

- Rede isolada para componentes da aplicacao.
- Banco de dados gerenciado para o WordPress.
- Storage persistente para uploads e temas.
- Load balancer ou endpoint publico controlado.
- Pipeline simples para validar Terraform.

## Status

Em planejamento.

## Proximos passos

1. Definir o provedor cloud alvo.
2. Escolher arquitetura inicial: VM, ECS, EKS ou Kubernetes local.
3. Criar os primeiros recursos Terraform.
4. Adicionar validacao com `terraform fmt` e `terraform validate`.
5. Documentar custos, premissas e limites do laboratorio.
