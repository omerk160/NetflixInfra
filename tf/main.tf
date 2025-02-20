terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.55" # Specify the AWS provider version
    }
  }

  required_version = ">= 1.7.0" # Specify the required Terraform version


  backend "s3" {
    bucket = "omer-tf-netflix-infra-s3"
    key    = "tfstate.json"
    region = "eu-north-1"
  }
}

provider "aws" {
  region  = var.region # AWS region to deploy resources
  profile = "default"  # AWS CLI profile to use
}

resource "aws_key_pair" "netflix_key" {
  key_name   = "netflix_key"                         # Name of the key pair
  public_key = file("./netflix_tf_key.pub") # Path to the public key file
}

resource "aws_instance" "netflix_app" {
  #ami             = "ami-02e2af61198e99faf"  # Amazon Machine Image ID
  ami             = var.ami_id
  instance_type   = "t3.micro"                               # EC2 instance type
  key_name        = aws_key_pair.netflix_key.key_name        # Key pair to use for the instance
  user_data       = file("./deploy.sh")                      # Script to run on instance launch
  security_groups = [aws_security_group.netflix_app_sg.name] # Security group to associate

  tags = {
    Name      = "omer_tf_netflix_stack_3${var.env}" # Tag for the instance
    Terraform = "Owned"                             # Tag indicating ownership by Terraform
    Env       = var.env                             # Tag indicating the deployment environment
  }
}

resource "aws_security_group" "netflix_app_sg" {
  name        = "omer-netflix-app-sg"        # Name of the security group
  description = "Allow SSH and HTTP traffic" # Description of the security group

  ingress {
    from_port   = 22 # Allow SSH traffic
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from any IP
  }

  ingress {
    from_port   = 8080 # Allow HTTP traffic
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from any IP
  }

  egress {
    from_port   = 0 # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow to any IP
  }
}

resource "aws_ebs_volume" "netflix_data" {
  availability_zone = aws_instance.netflix_app.availability_zone # Availability zone for the volume
  size              = 5                                          # Size of the volume in GB
  tags = {
    Name = "NetflixData" # Tag for the volume
  }
}

resource "aws_iam_role" "netflix_app_role" {
  name = "omer-tff-role"             # Name of the IAM role
  assume_role_policy = jsonencode({ # Policy to allow EC2 to assume this role
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "ec2.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_volume_attachment" "netflix_data_attach" {
  device_name = "/dev/xvdf"                    # Device name for the volume
  volume_id   = aws_ebs_volume.netflix_data.id # ID of the volume to attach
  instance_id = aws_instance.netflix_app.id    # ID of the instance to attach the volume to
}