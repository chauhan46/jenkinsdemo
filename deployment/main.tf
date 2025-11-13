provider "aws" {
  region = "us-east-1"
}

#  Directly reference your VPC by ID
data "aws_vpc" "selected" {
  id = "vpc-08c662b7cbfd180fc"
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = ["vpc-08c662b7cbfd180fc"] 
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  subnet_id     = tolist(data.aws_subnets.selected.ids)[0]

  tags = {
    Name = "Terraform"
  }
}
