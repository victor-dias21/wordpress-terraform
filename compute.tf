data "aws_iam_policy_document" "wordpress_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "wordpress_instance" {
  statement {
    sid = "ReadDatabaseSecret"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [module.wordpress_database.db_instance_master_user_secret_arn]
  }

  statement {
    sid = "UseWordPressBucket"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      module.wordpress_bucket.s3_bucket_arn,
      "${module.wordpress_bucket.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role" "wordpress_instance" {
  name               = "${local.name_prefix}-ec2"
  assume_role_policy = data.aws_iam_policy_document.wordpress_assume_role.json
}

resource "aws_iam_role_policy" "wordpress_instance" {
  name   = "${local.name_prefix}-ec2"
  role   = aws_iam_role.wordpress_instance.id
  policy = data.aws_iam_policy_document.wordpress_instance.json
}

resource "aws_iam_instance_profile" "wordpress_instance" {
  name = "${local.name_prefix}-ec2"
  role = aws_iam_role.wordpress_instance.name
}

module "wordpress_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = "${local.name_prefix}-web"

  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.wordpress_security_group.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.wordpress_instance.name

  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/templates/user_data_wordpress.sh.tftpl", {
    aws_region      = var.aws_region
    db_name         = var.db_name
    db_secret_arn   = module.wordpress_database.db_instance_master_user_secret_arn
    db_endpoint     = module.wordpress_database.db_instance_address
    db_username     = var.db_username
    wordpress_url   = "https://${var.domain_name}"
    s3_bucket_name  = module.wordpress_bucket.s3_bucket_id
    wordpress_title = "WordPress Terraform Lab"
  })

  root_block_device = {
    size      = var.root_volume_size
    type      = "gp3"
    encrypted = true
  }
}
