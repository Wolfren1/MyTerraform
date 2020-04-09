provider "aws" {
  region = "us-east-1"
}

variable "image_id" {
  type = map
  default = {"us-east-1" = "ami-0323c3dd2da7fb37d"
        "us-west-1" = "ami-06fcc1f0bc2c8943f"
        "us-east-2" = "ami-0f7919c33c90f5b58"
  }
}

resource "aws_security_group" "new_sg" {
  name        = "allow_http"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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

  tags = {
    Name = "allow_http"
  }
}


resource "aws_key_pair" "keygen1" {
  key_name   = "kg1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6nAKvKaC9QByMWZu1die47Mkj6Iz4bRsOLGZRdgMOqcu41mNyhcl1rzwW82fgEfm+gO9eVPHh9GbZM+U4RDAeonQCjAdwsbzjoH9PnEFjScJj5un6JMIWNmfa6LZ1WwDQb8RI29WNWb8U/9nivIS5NARLyIy9NCfV/CcVybJoF2fmv7Chr2a9UY0MHw80tM3P+3It2U6aeL8yPomVrorQfEAGqlG13PhfcDcbE9G2AG5KeBkTcJ3sgDZ+Da2tggZrlF14Rlh3NeaxUL/Za3Y60pqTEx6JjyGRxcU8i5NyC6O29tsKtzjbG3tePtxXDKt9nphhV4SZmpTDmCp4Z22/ ec2-user@ip-172-31-83-226.ec2.internal"

}


resource "aws_instance" "web" {
  ami           = lookup(var.image_id, "us-east-1")
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.keygen1.key_name}"
  security_groups = ["${aws_security_group.new_sg.name}"]

  tags = {
    Name = "AppServer1"
  }
}

output "ip_address" {
  value = "${aws_instance.web.public_ip}"
}
