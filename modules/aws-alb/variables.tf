variable "backend_port" {
  description = "The port the service on the EC2 instances listen on."
  type        = number
  default     = 80
}

variable "backend_protocol" {
  description = "The protocol the backend service speaks. Options: HTTP, HTTPS, TCP, SSL (secure tcp)."
  type        = string
  default     = "HTTP"
}

variable "backend_sg_id" {
  description = "Security group ID of the instance to add rule to allow incoming tcp from ALB"
  type        = string
}

variable "domain_name" {
  description = "Domain name of a private Route 53 zone to create DNS record in"
  type        = string
}

variable "hostname" {
  description = "Optional hostname that will be used to created a sub-domain in Route 53. If left blank then a record will be created for the root domain (ex. example.com)"
  type        = string
}

variable "internal" {
  description = "Use an internal load-balancer (default=false)"
  type        = bool
  default     = false
}

variable "private_zone" {
  description = "Private Route 53 zone (default=false)"
  type        = bool
  default     = false
}

variable "log_bucket_name" {
  description = "Name of the log bucket to create"
  type        = string
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
  description = "List of subnets to put instances in"
  type        = list
}
