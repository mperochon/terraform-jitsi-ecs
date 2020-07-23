 
variable "name" {
    description = "Name of the app."
    type        = string
}

variable "vpc_private_subnets" {
   description = "List of private subnets to put instances in"
   type        = list
}

variable "vpc_public_subnets" {
    description = "List of public subnets to put instances in"
    type        = list
}

variable "vpc_id" {
    description = "VPC Id"
    type        = string
    default     = ""
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

variable "jitsi_secret_bucket_name" {
  description = "Bucket name of jitsi secret"
  type        = string
  default     = "jitsi-config"
}

variable "web_environment_filename" {
  description = "Name of the web environment filename"
  type        = string
  default     = "web.env"
}

variable "prosody_environment_filename" {
  description = "Name of the prosody environment filename"
  type        = string
  default     = "prosody.env"
}

variable "jvb_environment_filename" {
  description = "Name of the jvb environment filename"
  type        = string
  default     = "jvb.env"
}

variable "jicofo_environment_filename" {
  description = "Name of the jicofo environment filename"
  type        = string
  default     = "jicofo.env"
}

variable "aws_region" {
  description = "aws region name"
  type        = string
}

variable "instance_keypair" {
  description = "Aws keypair name"
  type        = string
}

variable "instance_type" {
  description = "ECS instance type"
  type        = string
  default     = "t3a.xlarge"
}

variable "jibri_xmpp_user" {
  description = "Jibri xmpp user"
  type        = string
  default     = "jibri"
}

variable "jibri_xmpp_password" {
  description = "Jibri xmpp password"
  type        = string
}

variable "jibri_recorder_user" {
  description = "Jibri recorder user"
  type        = string
  default     = "recorder"
}

variable "jibri_recorder_password" {
  description = "Jibri recorder password"
  type        = string
}

variable "jigasi_xmpp_user" {
  description = "Jigasi xmpp user"
  type        = string
  default     = "jigasi"
}

variable "jigasi_xmpp_password" {
  description = "Jigasi xmpp password"
  type        = string
}

variable "jvb_auth_user" {
  description = "JVB auth user"
  type        = string
  default     = "jvb"
}

variable "jvb_auth_password" {
  description = "JVB auth password"
  type        = string
}

variable "jicofo_auth_user" {
  description = "Jicofo auth user"
  type        = string
  default     = "focus"
}

variable "jicofo_auth_password" {
  description = "Jicofo auth password"
  type        = string
}

variable "jicofo_component_secret" {
  description = "Jicofo component secret"
  type        = string
}

variable "jitsi_timezone" {
  description = "Jicofo component secret"
  type        = string
  default     = "UTC"
}

variable "alb_log_bucket_name" {
  description = "Name of the ALB log bucket to create"
  type        = string
}