resource "aws_vpc" "ansible" {
  cidr_block = var.vpc-cidr
  tags = {
    "Name" = "Ansible"
  }
}


resource "aws_internet_gateway" "internetgatway" {
  vpc_id = aws_vpc.terraform.id

  tags = {
    Name = "Ansible internetgateway"
  }
}