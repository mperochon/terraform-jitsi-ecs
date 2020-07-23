# JITSI MEET

## GOAL

Deploy a jitsi meet instance on ECS

## USAGE
```
module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "~> 2.44.0"

    name               = "VPC_NAME"
    cidr               = "192.168.0.0/16"
    azs                = ["eu-west-2a", "eu-west-2b"]
    private_subnets    = ["192.168.1.0/24", "192.168.2.0/24"]
    public_subnets     = ["192.168.3.0/24", "192.168.4.0/24"]
    enable_nat_gateway = false
    single_nat_gateway = false
    tags               = {
                            environment = "dev"
                            version = "1.0.0"
                            component = "jitsi-vpc"
                            owner = "me"
                        }
}

module "jitsi" {
  source = "./modules/jitsi-aws-ecs"

  name = var.name
  hostname                   = "jitsi"
  domain_name                = "example.com"
  vpc_id                     = module.vpc.vpc_id
  vpc_public_subnets         = module.vpc.public_subnets
  vpc_private_subnets        = module.vpc.private_subnets
  tags                       = {
                                    environment = "dev"
                                    version = "1.0.0"
                                    component = "jitsi-meet"
                                    owner = "me"
                                }
  aws_region                 = "eu-west-2"
  jitsi_secret_bucket_name   = "jitsi-config-bucket"
  instance_keypair           = "my_keypair"
  alb_log_bucket_name        = "jitsi-alb-log-bucket"

  jibri_xmpp_user            = "jibri"
  jibri_xmpp_password        = "PASSWORD_JIBRI"
  jibri_recorder_user        = "recorder"
  jibri_recorder_password    = "PASSWORD_RECORDER"
  jigasi_xmpp_user           = "jigasi"
  jigasi_xmpp_password       = "PASSWORD_JIGASI"
  jvb_auth_user              = "jvb"
  jvb_auth_password          = "PASSWORD_JVB"
  jicofo_auth_user           = "jicofo"
  jicofo_auth_password       = "PASSWORD_JICOFO"
  jicofo_component_secret    = "SECRET_JICOFO"
  jitsi_timezone             = "UTC"
}
```