output "securitygroup_id" {
  value       = aws_security_group.test.id
  description = "The id of the security group"
  sensitive   = false
}

output "instancepublic_ip" {
  value       = aws_instance.test_instance.public_ip
  description = "Public IP address of the instance"
  sensitive   = false
}
