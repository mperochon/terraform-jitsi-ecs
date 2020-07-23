variable "additional_user_data_script" {
  description = "Additional user data script (default=\"\")"
  type        = string
  default     = ""
}

variable "asg_max_size" {
  description = "Maximum number EC2 instances"
  type        = number
  default     = 2
}

variable "asg_min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "asg_desired_size" {
  description = "Desired number of instances"
  type        = number
  default     = 1
}

variable "image_id" {
  description = "AMI image_id for ECS instance"
  type        = string
  default     = ""
}

variable "instance_keypair" {
  description = "Instance keypair name"
  type        = string
  default     = ""
}

variable "instance_log_group" {
  description = "Instance log group in CloudWatch Logs"
  type        = string
  default     = ""
}

variable "instance_root_volume_size" {
  description = "Root volume size (default=50)"
  type        = number
  default     = 50
}

variable "instance_type" {
  description = "EC2 instance type (default=t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "name" {
  description = "Base name to use for resources in the module"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID to create cluster in"
  type        = string
}

variable "vpc_subnets" {
  description = "List of VPC private subnet Ids to put instances in"
  type        = list
}
