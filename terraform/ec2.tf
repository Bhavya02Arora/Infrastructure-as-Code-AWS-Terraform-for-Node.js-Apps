/* 
Requirements
1. create ec2.
2. SG group:
open port
443 (HTTPS)
3000 (NodeJS)
*/


resource "aws_instance" "tf_ec2_instance" {
  # ami           = "ami-04b4f1a9cf54c11d0" #ubuntu image
  ami           =  data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.tf_ec2_sg.id ]
  key_name = "MyKeyPair"
  depends_on = [aws_s3_object.s3_object_tf] # this will get created 
  # first before ec2 spins up

  user_data       = file("script.sh")
  tags = {
    Name = "NodeJS-server"
  }
}


#security group
resource "aws_security_group" "tf_ec2_sg" {
  name        = "node-js-server-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = "vpc-0dbcc239587758722"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # open to all the IP addreses, we can limi it to only one machine as well
  }

  ingress {
    description = "TCP"
    from_port   = 3000 # for nodejs app
    to_port     = 3000
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
    Name = "nodejs-sg"
  }
}


