output "netflix_app_ami" {
  value = module.netflix_app.netflix_app_ami
}

output "ec2_public_ip" {
  value = module.netflix_app.ec2_public_ip
}
