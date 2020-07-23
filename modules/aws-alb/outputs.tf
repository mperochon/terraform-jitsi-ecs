output "listener_https_arns" {
  description = "The ARN of the HTTPS ALB Listener that can be used to add rules"
  value       = "${module.alb.https_listener_arns}"
}

output "target_group_arns" {
  description = "ARN of the target group"
  value       = "${module.alb.target_group_arns}"
}
