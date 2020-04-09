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
  public_key = "${file("/home/ec2-user/kg1.pub")}"

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
