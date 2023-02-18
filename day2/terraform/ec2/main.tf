



resource "aws_security_group" "sec-group-terraform" {
  name        = "terraform-secgroup"
  description = "Security group for allowing http "
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ var.all-trafic-cidr ]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = [ var.all-trafic-cidr ]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [ var.all-trafic-cidr ]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ var.all-trafic-cidr ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ var.all-trafic-cidr ]
  }
}


resource "aws_instance" "jump_host" {
 ami           = var.default-ami
 instance_type = var.default-instance-type
 associate_public_ip_address = true
 subnet_id     = var.public_subnet_id
 vpc_security_group_ids = [aws_security_group.sec-group-terraform.id ]
 key_name = "ansible"
 provisioner "local-exec" {
    when = create
    command = "echo public-bastion ${self.public_ip} >> ./all-ips.txt"
  } 
 tags = {
    Name = "jumphost"
  }

}


resource "aws_instance" "private-nexus" {
  ami           = var.default-ami
 instance_type = var.default-instance-type
  associate_public_ip_address = false
  subnet_id = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.sec-group-terraform.id ]
  key_name = "ansible"
  provisioner "local-exec" {
    when = create
    command = "echo nexus-private-ip ${self.public_ip} >> ./all-ips.txt"
  } 
  tags = {
    Name = "nexus-vm"
  }
}

resource "aws_instance" "private-sonarQube" {
 ami           = var.default-ami
 instance_type = var.default-instance-type
  associate_public_ip_address = false
  subnet_id = var.private_subnet_id_2
  vpc_security_group_ids = [aws_security_group.sec-group-terraform.id ]
  provisioner "local-exec" {
    when = create
    command = "echo sonarQube-private-Ip ${self.public_ip} >> ./all-ips.txt"
  } 
  key_name = "ansible"
  tags = {
    Name = "sonarqube-vm"
  }
}












 