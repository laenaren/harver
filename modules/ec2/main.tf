variable "instance_sg_name" {}
variable "instance_sg" {}
variable "public_lb_subnet" {}

resource "aws_key_pair" "harver_key" {
  key_name   = "Harver-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCs3Sl/U6w6BK2Zpz9RNaf2WfK1k++dgMA8x8QX2P1Af2V6xz34sWeUWYex1Q+9Kf3fvtewOKMto+8jbsvsNRLTB3y7oOg8e0g4e7hgOhzKgczx6CjK6LF9p2uM51q2i8RGFwrd07Sp5Gr7VYR3WsTzk2w9Q7wYEZQpwvioY69dy2SbGLHlvbIY1dd6hVH4v8DNcmPzD3Q1z7cK9bpgy9z6Rx7+tnqjzjObSMjNDJXlNqT9HbYHOwav6RfXBiTGAARM5zaP/anocyDF1jqCfei5nhi0lnGKvh6O8c1ewyWTiarFDIgQKywSIZJSetfwVb6vj3qLqRdYZU2QjRx59TyLhiIqsa15lieKqnxU6JLYvkuHp88rDiNXyHXrqIQb12JO1L1pcES8K5vJfNJ8aWUEJtUNtVxaGWKYZFIv/wCEBTiQwJgauOf1czTZnthaN/zzWVG3/YxnRr1b/xmpa2+DTYV1FwjQGQpswTrdRTUBHRexwEueJevDLDnxY9QGk6U= laenaren@Laenarens-MacBook-Pro.local"
}

# Get random external ip
resource "aws_eip" "lb" {}

resource "aws_instance" "web" {
  ami                    = "ami-03cc8375791cb8bcf" # Ubuntu
  vpc_security_group_ids = [var.instance_sg]       # Attach the security group
  subnet_id              = var.public_lb_subnet

  instance_type = "t2.micro"
  key_name      = aws_key_pair.harver_key.key_name

  # In a production scenario, this will probably an external file
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y apache2
              echo "<html><h1>Hello Harver</h1></html>" > /var/www/html/index.html
              sudo ufw allow 'Apache'
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo systemctl status apache2
              EOF

  tags = {
    Name = "Harver-web-instance"
  }

  # Enable public IP
  associate_public_ip_address = true

}


output "instance_id" {
  value = aws_instance.web.id
}
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}