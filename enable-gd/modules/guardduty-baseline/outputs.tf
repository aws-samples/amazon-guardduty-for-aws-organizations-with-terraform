output "guardduty_detector" {
  description = "The GuardDuty detector."
  value       = var.enabled ? aws_guardduty_detector.MyDetector[0].id : null
}
