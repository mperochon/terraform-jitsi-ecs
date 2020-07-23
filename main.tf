data "aws_region" "current" {}

module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "~> 2.44.0"

    name               = var.name
    cidr               = var.cidr
    azs                = var.azs
    private_subnets    = var.vpc_private_subnets
    public_subnets     = var.vpc_public_subnets
    enable_nat_gateway = false
    single_nat_gateway = false
    tags               = var.tags
}

module "jitsi" {
  source = "./modules/jitsi-aws-ecs"

  name = var.name
  hostname                   = var.hostname
  domain_name                = var.domain_name
  vpc_id                     = module.vpc.vpc_id
  vpc_public_subnets         = module.vpc.public_subnets
  vpc_private_subnets        = module.vpc.private_subnets
  tags                       = var.tags
  aws_region                 = data.aws_region.current.name
  jitsi_secret_bucket_name   = var.jitsi_secret_bucket_name
  instance_keypair           = var.instance_keypair
  alb_log_bucket_name        = var.alb_log_bucket_name

  jibri_xmpp_user            = var.jibri_xmpp_user
  jibri_xmpp_password        = var.jibri_xmpp_password
  jibri_recorder_user        = var.jibri_recorder_user
  jibri_recorder_password    = var.jibri_recorder_password
  jigasi_xmpp_user           = var.jigasi_xmpp_user
  jigasi_xmpp_password       = var.jigasi_xmpp_password
  jvb_auth_user              = var.jvb_auth_user
  jvb_auth_password          = var.jvb_auth_password
  jicofo_auth_user           = var.jicofo_auth_user
  jicofo_auth_password       = var.jicofo_auth_password
  jicofo_component_secret    = var.jicofo_component_secret
  jitsi_timezone             = var.jitsi_timezone
}
