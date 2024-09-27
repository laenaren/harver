
# create vpc vpc
resource "aws_vpc" "harver_vpc" {
  cidr_block = "10.1.0.0/24" # a small CIDR block just  because we dont need a lot of addresses
  tags = {
    Name = "Harver_Assigment_VPC"
  }
}


# Create subnets

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.harver_vpc.id
  cidr_block        = "10.1.0.0/25"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "main_subnet"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.harver_vpc.id
  cidr_block        = "10.1.0.128/25"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "secondary_subnet"
  }
}

# Create a security group for the EC2 instance

resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.harver_vpc.id
  name   = "webinstance_sg_Harver"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance_sg"
  }
}

# Create a security group for the load balancer
resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.harver_vpc.id
  name   = "LB_sg_Harver"


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb_sg"
  }
}

# Create an Internet Gateway for the VPC public subenets to use

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.harver_vpc.id

  tags = {
    Name = "harver_igw"
  }
}

# Create a Public Subnet Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.harver_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Associate the Route Table with the Public Subnets
resource "aws_route_table_association" "public_subnet_assoc_1" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_subnet_assoc_2" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.public_route_table.id
}


# outputs

output "security_group_id" {
  value       = aws_security_group.instance_sg.id
  description = "id of security group"
}
output "public_lb_subnet" {
  value = aws_subnet.main.id
}
output "public_lb_secondary_subnet" {
  value = aws_subnet.secondary.id
}
output "alb_sg_id" {
  value = aws_security_group.lb_sg.id
}
output "vpc_id" {
  value = aws_vpc.harver_vpc.id
}
output "instance_sg" {
  value = aws_security_group.instance_sg.id
}
output "instance_sg_name" {
  value = aws_security_group.instance_sg.name
}