provider "aws" {
  profile = "aws-profile-name"
  region  = "ap-northeast-1"
}

# VPC
module "vpc" {
  source       = "../../modules/vpc"
  project_name = var.project_name
  environment  = var.environment
}

# subnet(public and private)
module "subnet" {
  source       = "../../modules/subnet"
  project_name = var.project_name
  environment  = var.environment
  vpc_this     = module.vpc.vpc_this
}

# ===================================
# for public subnet
# ===================================

# internet gateway
module "igw" {
  source       = "../../modules/igw"
  project_name = var.project_name
  environment  = var.environment
  vpc_this     = module.vpc.vpc_this
}

# route table
module "route_table_public" {
  source           = "../../modules/route/table"
  project_name     = var.project_name
  environment      = var.environment
  route_table_role = "public"
  vpc_this         = module.vpc.vpc_this
  subnets          = module.subnet.public_subnets
}

# route attach igw
module "route_attach_igw" {
  source           = "../../modules/route"
  route_table_this = module.route_table_public.route_table_this
  igw_this         = module.igw.igw_this
}

# security group
module "security_group_public" {
  source              = "../../modules/security_group"
  project_name        = var.project_name
  security_group_role = "public"
  environment         = var.environment
  vpc_this            = module.vpc.vpc_this
}

# security group rule 
module "security_group_public_in_ssh" {
  source              = "../../modules/security_group/rule"
  security_group_this = module.security_group_public.security_group_this
  type                = "ingress"
  from_port           = 22
  to_port             = 22
}

# security group rule
module "security_group_public_in_http" {
  source              = "../../modules/security_group/rule"
  security_group_this = module.security_group_public.security_group_this
  type                = "ingress"
  from_port           = 80
  to_port             = 80
}

# security group rule
module "security_group_public_in_https" {
  source              = "../../modules/security_group/rule"
  security_group_this = module.security_group_public.security_group_this
  type                = "ingress"
  from_port           = 443
  to_port             = 443
}

# security group rule
module "security_group_public_out_all" {
  source              = "../../modules/security_group/rule"
  security_group_this = module.security_group_public.security_group_this
  type                = "egress"
  from_port           = 0
  to_port             = 0
  protocol            = -1
}

# key pair
module "key_pair" {
  source       = "../../modules/key_pair"
  project_name = var.project_name
  environment  = var.environment
  ssh_key_path = file("./ssh_key/id_rsa.pub")
}

# load balancer
module "lb" {
  source              = "../../modules/lb"
  project_name        = var.project_name
  environment         = var.environment
  load_balancer_type  = "application"
  vpc_this            = module.vpc.vpc_this
  security_group_this = module.security_group_public.security_group_this
  public_subnets      = module.subnet.public_subnets
}

# load balancer target group dummy
module "lb_target_group_dummy" {
  source            = "../../modules/lb/target_group"
  project_name      = var.project_name
  environment       = var.environment
  terget_group_role = "dummy"
  vpc_this          = module.vpc.vpc_this
  lb_this           = module.lb.lb_this
}

# listenerはどれかのtarget_groupをデフォルトとして紐付ける必要あるためdummyを紐付けておく（使わない）
module "lb_listener" {
  source               = "../../modules/lb/listener"
  project_name         = var.project_name
  environment          = var.environment
  lb_this              = module.lb.lb_this
  lb_target_group_this = module.lb_target_group_dummy.lb_target_group_this
  certificate_arn      = var.alb_certificate_arn
}

# ===================================
# for private subnet
# 必要に応じてprivate subnetにnatを設定する
# ===================================

# route table
module "route_table_private" {
  source           = "../../modules/route/table"
  project_name     = var.project_name
  environment      = var.environment
  route_table_role = "private"
  vpc_this         = module.vpc.vpc_this
  subnets          = module.subnet.private_subnets
}

# Elastic IP
module "eip_nat_subnet_1a" {
  source       = "../../modules/eip"
  project_name = var.project_name
  environment  = var.environment
  eip_role     = "nat_1a"
}

# NAT gateway
module "nat_gateway_subnet_1a" {
  source       = "../../modules/nat_gateway"
  project_name = var.project_name
  environment  = var.environment
  nat_role     = "nat_1a"
  eip_this     = module.eip_nat_subnet_1a.eip_this
  subnet       = module.subnet.private_subnets.subnet-1a
}

# route attach NAT gateway
module "route_attach_nat_1a" {
  source           = "../../modules/route"
  route_table_this = module.route_table_private.route_table_this
  nat_gateway_this = module.nat_gateway_subnet_1a.nat_gateway_this
}

# ===================================
# ここから先　EC2
# ===================================

# ec2
module "ec2_web" {
  source              = "../../modules/ec2"
  project_name        = var.project_name
  environment         = var.environment
  instance_role       = "web"
  instance_type       = "t2.micro"
  ami_id              = var.instance_ami_id
  instance_count      = var.instance_count
  security_group_this = module.security_group_public.security_group_this
  key_pair_this       = module.key_pair.key_pair_this
  public_subnets      = module.subnet.public_subnets
}

# load balancer target group
module "lb_target_group_web" {
  source            = "../../modules/lb/target_group"
  project_name      = var.project_name
  environment       = var.environment
  terget_group_role = "web"
  vpc_this          = module.vpc.vpc_this
  lb_this           = module.lb.lb_this
}

# load balancer target group attachment
module "lb_target_group_attachment_web" {
  source               = "../../modules/lb/target_group/attachment"
  lb_target_group_this = module.lb_target_group_web.lb_target_group_this
  aws_instance_this    = module.ec2_web.aws_instance_this
}

# ec2
module "ec2_api" {
  source              = "../../modules/ec2"
  project_name        = var.project_name
  environment         = var.environment
  instance_role       = "api"
  instance_type       = "t2.micro"
  ami_id              = var.instance_ami_id
  instance_count      = var.instance_count
  security_group_this = module.security_group_public.security_group_this
  key_pair_this       = module.key_pair.key_pair_this
  public_subnets      = module.subnet.public_subnets
}

# load balancer target group
module "lb_target_group_api" {
  source            = "../../modules/lb/target_group"
  project_name      = var.project_name
  environment       = var.environment
  terget_group_role = "api"
  vpc_this          = module.vpc.vpc_this
  lb_this           = module.lb.lb_this
}

# load balancer target group attachment
module "lb_target_group_attachment_api" {
  source               = "../../modules/lb/target_group/attachment"
  lb_target_group_this = module.lb_target_group_api.lb_target_group_this
  aws_instance_this    = module.ec2_api.aws_instance_this
}

# 80を443へリダイレクトさせるので設定不要
# # 振り分けはlistener_roleとしてルールを付与する
# module "lb_listener_rule_web_http" {
#   source               = "../../modules/lb/listener/rule_path_pattern"
#   project_name         = var.project_name
#   environment          = var.environment
#   lb_listener_this     = module.lb_listener.lb_listener_http
#   lb_target_group_this = module.lb_target_group_web.lb_target_group_this
#   priority             = 1000
#   condition_values     = ["/*"]
# }

# # 振り分けはlistener_roleとしてルールを付与する
# module "lb_listener_rule_api_http" {
#   source               = "../../modules/lb/listener/rule_path_pattern"
#   project_name         = var.project_name
#   environment          = var.environment
#   lb_listener_this     = module.lb_listener.lb_listener_http
#   lb_target_group_this = module.lb_target_group_api.lb_target_group_this
#   priority             = 100
#   condition_values     = ["/api/*"]
# }

# 振り分けはlistener_roleとしてルールを付与する
module "lb_listener_rule_web_https" {
  source               = "../../modules/lb/listener/rule_path_pattern"
  project_name         = var.project_name
  environment          = var.environment
  lb_listener_this     = module.lb_listener.lb_listener_https
  lb_target_group_this = module.lb_target_group_web.lb_target_group_this
  priority             = 1000
  condition_values     = ["/*"]
}

# 振り分けはlistener_roleとしてルールを付与する
module "lb_listener_rule_api_https" {
  source               = "../../modules/lb/listener/rule_path_pattern"
  project_name         = var.project_name
  environment          = var.environment
  lb_listener_this     = module.lb_listener.lb_listener_https
  lb_target_group_this = module.lb_target_group_api.lb_target_group_this
  priority             = 100
  condition_values     = ["/api/*"]
}

# ===================================
# ここから先　auto scaling関連
# ===================================

# auto scaling 起動設定
module "launch_configuration_web" {
  source              = "../../modules/launch_configuration"
  project_name        = var.project_name
  environment         = var.environment
  instance_role       = "web"
  instance_type       = "t2.micro"
  ami_id              = var.instance_ami_id
  security_group_this = module.security_group_public.security_group_this
  key_pair_this       = module.key_pair.key_pair_this
}

# # auto scaling group
# # 既存EC2にattachmentはできない（2020/11現在）
# # TODO:起動ポリシーについて作り込み
# module "auto_scaling_group_web" {
#   source                    = "../../modules/auto_scaling_group"
#   project_name              = var.project_name
#   environment               = var.environment
#   instance_role             = "web"
#   launch_configuration_this = module.launch_configuration_web.launch_configuration_this
#   lb_target_group_this      = module.lb_target_group_web.lb_target_group_this
#   public_subnets            = module.subnet.public_subnets
# }

# ===================================
# ここから先　DB関連
# ===================================

# security group(for rds)
module "security_group_db" {
  source              = "../../modules/security_group"
  project_name        = var.project_name
  security_group_role = "db"
  environment         = var.environment
  vpc_this            = module.vpc.vpc_this
}

# security group rule
module "security_group_public_in_mysql" {
  source              = "../../modules/security_group/rule"
  security_group_this = module.security_group_db.security_group_this
  type                = "ingress"
  from_port           = 3306
  to_port             = 3306
}

# db subnet group(private subunets)
module "subnet_group_db" {
  source       = "../../modules/subnet/group/db"
  project_name = var.project_name
  environment  = var.environment
  subnets      = module.subnet.private_subnets
}

# # db instance
# module "db_instance" {
#   source                 = "../../modules/db_instance"
#   project_name           = var.project_name
#   environment            = var.environment
#   engine                 = "mysql"
#   engine_version         = "5.7.31"
#   instance_class         = "db.t2.micro"
#   allocated_storage      = 20
#   username               = "admin"
#   password               = "v8QVb3xL"
#   parameter_group_name   = "default.mysql5.7"
#   option_group_name      = "default:mysql-5-7"
#   vpc_security_group_ids = [module.security_group_db.security_group_this.id]
#   subnet_group_name      = module.subnet_group_db.db_subnet_group_this.name
# }

# ===================================
# ここから先　s3バケット
# ===================================

# s3 bukcet
module "s3_cloudfront_logs" {
  source       = "../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
  bucket_role  = "cloudfront-logs"
}

module "s3_maintenance_html" {
  source       = "../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
  bucket_role  = "maintenance"
}

# s3 bukcet
module "s3_logs" {
  source       = "../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
  bucket_role  = "logs"
}


# ===================================
# ここから先　certification manager
# ===================================



# ===================================
# ここから先　cloudfront
# ===================================
module "cloudfront" {
  source              = "../../modules/cloudfront"
  project_name        = var.project_name
  environment         = var.environment
  lb_this             = module.lb.lb_this
  aliases             = var.cf_aliases
  acm_certificate_arn = var.cf_certificate_arn
}

module "route53_a_records" {
  source        = "../../modules/route53/records/a"
  zone_id       = var.route53_zone_id
  name          = var.route53_name
  alias_name    = module.cloudfront.cloudfront_distribution_this.domain_name
  alias_zone_id = module.cloudfront.cloudfront_distribution_this.hosted_zone_id
}

# ===================================
# ここから先　SES
# ===================================

module "ses_domain" {
  source       = "../../modules/ses/domain"
  project_name = var.project_name
  environment  = var.environment
  domain       = var.ses_domain
}

module "ses_email" {
  source       = "../../modules/ses/email"
  project_name = var.project_name
  environment  = var.environment
  emails       = var.ses_mail
}

# ドメインをRoute53管理の場合はRecodeを追加
# お名前.com等を利用している場合はTXT、CNAME、MXをそれぞれのサービスに設定する

# ===================================
# ここから先　SQS
# ===================================

module "sqs" {
  source       = "../../modules/sqs"
  project_name = var.project_name
  environment  = var.environment
  name         = "log-test"
}


# ===================================
# ここから先　SNS
# ===================================

module "sns_topic" {
  source       = "../../modules/sns/topic"
  project_name = var.project_name
  environment  = var.environment
  name         = "log-test"
}

# 作成済みsqsに通知する
module "sns_subscription_sqs" {
  source         = "../../modules/sns/subscription/sqs"
  project_name   = var.project_name
  environment    = var.environment
  sns_topic_this = module.sns_topic.sns_topic_this
  sqs_queue_this = module.sqs.sqs_queue_this
}

# SNSにSQSアクセス権限付与
module "sqs_policy" {
  source         = "../../modules/sqs/policy"
  project_name   = var.project_name
  environment    = var.environment
  sns_topic_this = module.sns_topic.sns_topic_this
  sqs_queue_this = module.sqs.sqs_queue_this
}

# ===================================
# ここから先　Route53
# ===================================

# Route53は手動設定する
# module "route53_web" {
#   source       = "../../modules/route53/hosted_zone"
#   project_name = var.project_name
#   environment  = var.environment
#   name         = "example.domain"
# }

# ===================================
# ここから先　ElastiCache
# ===================================

# cache subnet group(public subunets)
module "subnet_group_cache" {
  source       = "../../modules/subnet/group/cache"
  project_name = var.project_name
  environment  = var.environment
  subnets      = module.subnet.public_subnets
}

# security group rule
module "security_group_public_in_redis" {
  source              = "../../modules/security_group/rule"
  security_group_this = module.security_group_public.security_group_this
  type                = "ingress"
  from_port           = 6379
  to_port             = 6379
}

# # elasticache
# # クラスターシャード設定ではない
# # TODO:バックアップ設定
# module "elasticache_redis" {
#   source                = "../../modules/elasticache"
#   project_name          = var.project_name
#   environment           = var.environment
#   number_cache_clusters = 2
#   security_group_ids    = [module.security_group_public.security_group_this.id]
#   subnet_group_name     = module.subnet_group_cache.cache_subnet_group_this.name
# }

# # elasticache cluster redis
# module "elasticache_cluster_redis" {
#   source                             = "../../modules/elasticache/cluster"
#   project_name                       = var.project_name
#   environment                        = var.environment
#   elasticache_replication_group_this = module.elasticache_redis.elasticache_replication_group_this
# }

