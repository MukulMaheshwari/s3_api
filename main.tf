terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}
variable "key-name" {
  type = string
  default = "one2n"
}

resource "aws_iam_instance_profile" "s3-profile" {
  name = "s3_api_profile"
  role = "EC2_S3_Access"
}
resource "aws_instance" "api_server" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  key_name = var.key-name
  vpc_security_group_ids = ["sg-052853efdafae75d9"]
  iam_instance_profile = aws_iam_instance_profile.s3-profile.name
  user_data = <<EOF
#!/bin/bash
sudo su -
apt update
apt install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools -y
apt-get install awscli -y
pip install gunicorn flask
pip install boto3
git clone https://github.com/MukulMaheshwari/s3_api.git
cd s3_api
gunicorn --bind 0.0.0.0:5000 wsgi:app --daemon

EOF
  tags = {
    Name = "api_s3_one2n"
  }

}

  output "server_public_ipv4" {
    value = aws_instance.api_server.public_ip
}
