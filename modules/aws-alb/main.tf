module "sg_https" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "~> 3.12.0"
    
    name   = "${var.name}-alb"
    vpc_id = var.vpc_id

    ingress_with_cidr_blocks = [ {
            rule        = "https-443-tcp"
            cidr_blocks = "0.0.0.0/0"
        },
    ]

    egress_with_cidr_blocks = [ {
            rule        = "all-tcp"
            cidr_blocks = "0.0.0.0/0"
        },
    ]

    tags = "${var.tags}"
}

resource "aws_security_group_rule" "instance_attachment_tcp_to_alb" {
    type                     = "ingress"
    from_port                = 32768
    to_port                  = 61000
    protocol                 = "tcp"
    source_security_group_id = module.sg_https.this_security_group_id
    security_group_id        = var.backend_sg_id
}

resource "aws_acm_certificate" "default" {
    domain_name               = var.domain_name
    subject_alternative_names = ["*.${var.domain_name}"]
    validation_method         = "DNS"
    lifecycle {
        create_before_destroy = true
    }
}

data "aws_route53_zone" "domain" {
    name         = "${var.domain_name}."
    private_zone = var.private_zone
}

resource "aws_route53_record" "validation" {
    zone_id = data.aws_route53_zone.domain.zone_id
    name    = aws_acm_certificate.default.domain_validation_options.0.resource_record_name
    type    = aws_acm_certificate.default.domain_validation_options.0.resource_record_type
    records = ["${aws_acm_certificate.default.domain_validation_options.0.resource_record_value}"]
    ttl     = "300"
}

resource "aws_acm_certificate_validation" "default" {
  certificate_arn         = aws_acm_certificate.default.arn
  validation_record_fqdns = [
    "${aws_route53_record.validation.fqdn}",
  ]
}

module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "~> 5.6.0"

    internal            = var.internal
    name                = var.name
    security_groups     = ["${module.sg_https.this_security_group_id}"]

    subnets = var.vpc_subnets
    tags    = var.tags
    vpc_id  = var.vpc_id

    load_balancer_type = "application"

    target_groups = [
        {
        name_prefix      = "${var.name}-"
        backend_protocol = var.backend_protocol
        backend_port     = var.backend_port
        target_type      = "instance"
        }
    ]

    https_listeners = [
        {
            port               = 443
            protocol           = "HTTPS"
            certificate_arn    = aws_acm_certificate.default.arn
            target_group_index = 0
        }
    ]
}

resource "aws_route53_record" "hostname" {
    zone_id = data.aws_route53_zone.domain.zone_id
    name    = var.hostname != "" ? format("%s.%s", var.hostname, data.aws_route53_zone.domain.name) : format("%s", data.aws_route53_zone.domain.name)
    type    = "A"

    alias {
        name                   = module.alb.this_lb_dns_name
        zone_id                = module.alb.this_lb_zone_id
        evaluate_target_health = true
    }
}
