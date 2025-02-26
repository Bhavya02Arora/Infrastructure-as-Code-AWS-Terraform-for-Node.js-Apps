output "ec2_public_ip" {
  value = aws_instance.tf_ec2_instance.public_ip
}