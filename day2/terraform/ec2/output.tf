output "aws_public_instance-ip" {
  value = aws_instance.jump_host.id
}

output "aws_private_instance-ip" {
  value = aws_instance.private-nexus.id
}



output "aws_private_instance-ip-2" {
  value = aws_instance.private-sonarQube.id
}
