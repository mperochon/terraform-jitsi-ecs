 
variable "aws_region" {
  description = "AWS region name"
  type        = string
  default     = "eu-west-2"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "instance_keypair" {
  description = "AWS Instance keypair name"
  type        = string
}

variable "name" {
    description = "Name of the app."
    type        = string
    default     = "jitsi"
}

variable "tags" {
    description = "A map of tags to add to all resources"
    type        = map
    default     = {}
}

variable "hostname" {
    description = "Optional hostname that will be used to created a sub-domain in Route 53. If left blank then a record will be created for the root domain (ex. example.com)"
    type        = string
    default     = "jitsi"
}

variable "domain_name" {
  description = "Domain name of a private Route 53 zone to create DNS record in"
  type        = string
}

variable "cidr" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc_private_subnets" {
  description = "List of private subnets to put instances in"
  type        = list
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "List of public subnets to put instances in"
  type        = list
  default     = ["192.168.3.0/24", "192.168.4.0/24"]
}

variable "azs" {
  description = "List of availability zone"
  type        = list
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "jitsi_secret_bucket_name" {
  description = "Bucket name of jitsi secret"
  type        = string
  default     = "livestorm-jitsi-config"
}

variable "jitsi_environment_filename" {
  description = "Name of the jisti environment filename"
  type        = string
  default     = "jitsi.env"
}

variable "jibri_xmpp_user" {
  description = "Jibri xmpp user"
  type        = string
  default     = "jibri"
}

variable "jibri_xmpp_password" {
  description = "Jibri xmpp password"
  type        = string
  default     = "ee7f48bdaabf8ce7f90453e7dee5604e"
}

variable "jibri_recorder_user" {
  description = "Jibri recorder user"
  type        = string
  default     = "recorder"
}

variable "jibri_recorder_password" {
  description = "Jibri recorder password"
  type        = string
  default     = "3bfac28d75c0d3d88bfafb497bf123a1"
}

variable "jigasi_xmpp_user" {
  description = "Jigasi xmpp user"
  type        = string
  default     = "jigasi"
}

variable "jigasi_xmpp_password" {
  description = "Jigasi xmpp password"
  type        = string
  default     = "d6f5e10fcf5e2eb462805c3eb6c2011d"
}

variable "jvb_auth_user" {
  description = "JVB auth user"
  type        = string
  default     = "jvb"
}

variable "jvb_auth_password" {
  description = "JVB auth password"
  type        = string
  default     = "460cbbfc436a837d91b2deab1209f24d"
}

variable "jicofo_auth_user" {
  description = "Jicofo auth user"
  type        = string
  default     = "focus"
}

variable "jicofo_auth_password" {
  description = "Jicofo auth password"
  type        = string
  default     = "d9b267ad4453b22a43fcc785439336e5"
}

variable "jicofo_component_secret" {
  description = "Jicofo component secret"
  type        = string
  default     = "b005910d5b25504997d47d47c1e56255"
}

variable "jitsi_timezone" {
  description = "Jicofo component secret"
  type        = string
  default     = "UTC"
}

variable "alb_log_bucket_name" {
  description = "Name of the ALB log bucket to create"
  type        = string
  default     = "jitsi-log-alb"
}
