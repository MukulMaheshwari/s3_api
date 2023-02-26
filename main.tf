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
  default = "one2n_key"
}

resource "tls_private_key" "key_one" {
 algorithm = "RSA"
 rsa_bits = 4096
}
resource "local_file" "private_key" {
 content = tls_private_key.key_one.private_key_pem
 filename = "key_one.pem"
 file_permission = 0400
}
resource "aws_key_pair" "enter_key_name" {
 key_name = var.key-name
 public_key = tls_private_key.key_one.public_key_openssh
}
resource "aws_security_group" "test_one2n" {
  name        = "test_one2n"
  description = "Allow TCP 5000 and SSH 22"
  vpc_id      = "vpc-ab1bb0d6"
ingress {
    description = "HTTP"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_iam_role" "s3role" {
  name = "s3_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "ec2.amazonaws.com"
          },
       "Effect": "Allow",
      "Sid": ""
     }
   ]
 })
}

resource "aws_iam_policy" "s3policy" {
  name        = "s3_policy"
  path        = "/"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
     ]
  })
}


resource "aws_iam_policy_attachment" "s3-attach" {
  name       = "s3-attachment"
  roles     = [aws_iam_role.s3role.name]
  policy_arn = aws_iam_policy.s3policy.arn
}

resource "aws_iam_instance_profile" "s3_profile" {
  name = "test_profile"
  role = aws_iam_role.s3role.name
}

resource "aws_instance" "api_server" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  key_name = var.key-name
  vpc_security_group_ids = [aws_security_group.test_one2n.name]
  iam_instance_profile = aws_iam_instance_profile.s3_profile.name
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
