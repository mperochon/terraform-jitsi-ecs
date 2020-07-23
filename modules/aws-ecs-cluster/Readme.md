# AWS ECS CLUSTER

## GOAL

Create an ecs cluster for an application.

## USAGE

```
module "ecs_cluster" {
  source = "../aws-ecs-cluster"

  name                = "MY_ECS_CLUSTER"
  instance_type       = "t2.micro"
  vpc_id              = "MY VPC ID"
  vpc_subnets         = ["192.168.3.0/24", "192.168.4.0/24"]
  tags                = {
                          environment = "dev"
                          version = "1.0.0"
                          component = "ecs-cluster"
                          owner = "me"
                        }
  instance_keypair    = "MY_KEYPAIR_NAME"
}
```

## Credits

Based on [AWS ECS Cluster Terraform Module](https://github.com/anrim/terraform-aws-ecs/tree/master/modules/cluster)