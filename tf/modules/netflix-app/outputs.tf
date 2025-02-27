output "netflix_app_ami" {
  value = data.aws_ami.ubuntu_ami.id
}

output "ec2_public_ip" {
  value = aws_instance.netflix_app.public_ip
}
