# AWS Application load Balancer

## GOAL

Deploy an ALB with DNS registration and certificate creation (AWS CERTIFICATE MANAGER)

## USAGE
```
module "aws-alb"
    source = "./modules/aws-alb"

    name = "my-alb"

    hostname = "myalb"
    domain_name = "example.com"

    backend_sg_id = "${module.ecs_cluster.instance_sg_id}"
    backend_protocol = "HTTP"

    tags = {
        environment = "dev"
        version = "1.0.0"
        component = "alb"
        owner = "me"
    }

    vpc_id = "${module.vpc.vpc_id}"
    vpc_subnets = ["${module.vpc.public_subnets}"]

    log_bucket_name  = "MY_LOG_BUCKET_NAME"

```

## Credits

Based on [AWS ALB Terraform Module](https://github.com/anrim/terraform-aws-ecs/tree/master/modules/alb)
