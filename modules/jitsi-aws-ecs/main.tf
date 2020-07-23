resource "aws_s3_bucket" "jitsi_config_bucket" {
  bucket = var.jitsi_secret_bucket_name
  acl    = "private"
  tags   = var.tags
}

data "template_file" "web_environment_file" {
  template = file("${path.module}/container-definition/files/${var.web_environment_filename}")

  vars = {
    JIBRI_RECORDER_USER     = var.jibri_recorder_user
    JIBRI_RECORDER_PASSWORD = var.jibri_recorder_password
    JIBRI_XMPP_USER         = var.jibri_xmpp_user
    JIBRI_XMPP_PASSWORD     = var.jibri_xmpp_password
    JICOFO_AUTH_USER        = var.jicofo_auth_user
    TZ                      = var.jitsi_timezone
  }
}

resource "aws_s3_bucket_object" "web_env_file_s3_object" {
  bucket  = aws_s3_bucket.jitsi_config_bucket.id
  key     = var.web_environment_filename
  content = data.template_file.web_environment_file.rendered
}

data "template_file" "jicofo_environment_file" {
  template = file("${path.module}/container-definition/files/${var.jicofo_environment_filename}")

  vars = {
    JICOFO_COMPONENT_SECRET = var.jicofo_component_secret
    JICOFO_AUTH_USER        = var.jicofo_auth_user
    JICOFO_AUTH_PASSWORD    = var.jicofo_auth_password
    TZ                      = var.jitsi_timezone
  }
}

resource "aws_s3_bucket_object" "jicofo_env_file_s3_object" {
  bucket  = aws_s3_bucket.jitsi_config_bucket.id
  key     = var.jicofo_environment_filename
  content = data.template_file.jicofo_environment_file.rendered
}

data "template_file" "prosody_environment_file" {
  template = file("${path.module}/container-definition/files/${var.prosody_environment_filename}")

  vars = {
    JIBRI_RECORDER_USER     = var.jibri_recorder_user
    JIBRI_RECORDER_PASSWORD = var.jibri_recorder_password
    JIBRI_XMPP_USER         = var.jibri_xmpp_user
    JIBRI_XMPP_PASSWORD     = var.jibri_xmpp_password
    JICOFO_AUTH_USER        = var.jicofo_auth_user
    JICOFO_AUTH_PASSWORD    = var.jicofo_auth_password
    JICOFO_COMPONENT_SECRET = var.jicofo_component_secret
    JVB_AUTH_USER           = var.jvb_auth_user
    JVB_AUTH_PASSWORD       = var.jvb_auth_password
    JIGASI_XMPP_USER        = var.jigasi_xmpp_user
    JIGASI_XMPP_PASSWORD    = var.jigasi_xmpp_password
    TZ                      = var.jitsi_timezone
  }
}

resource "aws_s3_bucket_object" "prosody_env_file_s3_object" {
  bucket  = aws_s3_bucket.jitsi_config_bucket.id
  key     = var.prosody_environment_filename
  content = data.template_file.prosody_environment_file.rendered
}

data "template_file" "jvb_environment_file" {
  template = file("${path.module}/container-definition/files/${var.jvb_environment_filename}")

  vars = {
    JVB_AUTH_USER     = var.jvb_auth_user
    JVB_AUTH_PASSWORD = var.jvb_auth_password
    TZ                = var.jitsi_timezone
  }
}

resource "aws_s3_bucket_object" "jvb_env_file_s3_object" {
  bucket  = aws_s3_bucket.jitsi_config_bucket.id
  key     = var.jvb_environment_filename
  content = data.template_file.jvb_environment_file.rendered
}

module "ecs_cluster" {
    source = "../aws-ecs-cluster"

    name                = var.name
    instance_type       = var.instance_type
    vpc_id              = var.vpc_id
    vpc_subnets         = var.vpc_public_subnets
    tags                = var.tags
    instance_keypair    = var.instance_keypair
}

resource "aws_security_group_rule" "instance_attachment_jvb_udp_to_everywhere" {
    type                     = "ingress"
    from_port                = 10000
    to_port                  = 10000
    protocol                 = "udp"
    cidr_blocks              = ["0.0.0.0/0"]
    security_group_id        = module.ecs_cluster.instance_sg_id
}

resource "aws_security_group_rule" "jitsi_attachment_udp_out_all" {
    type              = "egress"
    from_port         = 0
    to_port           = 65535
    protocol          = "udp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = module.ecs_cluster.instance_sg_id
}

module "alb" {
    source           = "../aws-alb"

    name             = var.name
    hostname         = var.hostname
    domain_name      = var.domain_name
    backend_sg_id    = module.ecs_cluster.instance_sg_id
    backend_protocol = "HTTPS"
    tags             = var.tags
    vpc_id           = var.vpc_id
    vpc_subnets      = var.vpc_public_subnets
    log_bucket_name  = var.alb_log_bucket_name
}

resource "aws_cloudwatch_log_group" "ecs_svc_jitsi_web" {
  name = "ecs-svc-jitsi-web"

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs_svc_jitsi_jicofo" {
  name = "ecs-svc-jitsi-jicofo"

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs_svc_jitsi_jvb" {
  name = "ecs-svc-jitsi-jvb"

  tags = var.tags
}


resource "aws_cloudwatch_log_group" "ecs_svc_jitsi_prosody" {
  name = "ecs-svc-jitsi-prosody"

  tags = var.tags
}

resource "aws_iam_role" "ecs_execution_role" {
    name = "${var.name}-ecs-execution-role"

    assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [ {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    } ]
}
EOF
}

resource "aws_iam_role" "ecs_task_role" {
    name = "${var.name}-ecs-task-role"

    assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [ {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    } ]
}
EOF
}

resource "aws_iam_policy" "s3_ecs_policy" {
  name        = "s3_ecs_policy"
  description = "s3 ecs policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
          "s3:GetObject",
          "s3:GetBucketLocation"
      ],
      "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.jitsi_config_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.jitsi_config_bucket.id}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_ecs_task_policy_attachment" {
    role       = aws_iam_role.ecs_execution_role.name
    policy_arn = aws_iam_policy.s3_ecs_policy.arn
}

resource "aws_iam_policy" "cloudwatch_ecs_policy" {
  name        = "cloudwatch_ecs_policy"
  description = "cloudwatch ecs policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ],
      "Resource": [
          "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_ecs_task_policy_attachment" {
    role       = aws_iam_role.ecs_execution_role.name
    policy_arn = aws_iam_policy.cloudwatch_ecs_policy.arn
}

data "template_file" "jitsi_ecs_task_container_definitions" {
  template = file("${path.module}/container-definition/jitsi-container-definition.json")

  vars = { 
    S3_WEB_ENV_FILE_PATH     = "arn:aws:s3:::${var.jitsi_secret_bucket_name}/${var.web_environment_filename}"
    S3_JICOFO_ENV_FILE_PATH  = "arn:aws:s3:::${var.jitsi_secret_bucket_name}/${var.jicofo_environment_filename}"
    S3_PROSODY_ENV_FILE_PATH = "arn:aws:s3:::${var.jitsi_secret_bucket_name}/${var.prosody_environment_filename}"
    S3_JVB_ENV_FILE_PATH     = "arn:aws:s3:::${var.jitsi_secret_bucket_name}/${var.jvb_environment_filename}"
    AWS_REGION               = var.aws_region
  }
}

resource "aws_ecs_task_definition" "jitsi_app" {
  family                   = var.name
  container_definitions    = data.template_file.jitsi_ecs_task_container_definitions.rendered
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  volume {
    name      = "jicofo-storage"
    host_path = "/ecs/service-storage/jicofo"
  }

  volume {
    name      = "jvb-storage"
    host_path = "/ecs/service-storage/jvb"
  }

  volume {
    name      = "prosody-storage"
    host_path = "/ecs/service-storage/prosody"
  }

  volume {
    name      = "prosody-plugins-storage"
    host_path = "/ecs/service-storage/prosody-plugins"
  }

  volume {
    name      = "web-storage"
    host_path = "/ecs/service-storage/web-plugins"
  }

  volume {
    name      = "web-transcripts-storage"
    host_path = "/ecs/service-storage/web-transcripts-plugins"
  }
}

module "ecs_service_web" {
    source = "../aws-ecs-service"

    name                 = "${var.name}-web"
    alb_target_group_arn = module.alb.target_group_arns[0]
    cluster              = module.ecs_cluster.cluster_id
    container_name       = "web"
    container_port       = "443"
    log_groups           = ["${var.name}-jitsi-web-server"]
    task_definition_arn  = aws_ecs_task_definition.jitsi_app.arn
    tags                 = var.tags
}
