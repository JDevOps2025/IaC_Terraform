# EC2 instances configuration running Nginx web servers, distributed across two availability zones for high availability. 

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# Web Server 1 (Public Subnet 1, AZ1)

resource "aws_instance" "web_1" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  associate_public_ip_address = true

  # Script to install and configure Nginx
  user_data = base64encode(templatefile("${path.module}/script.sh", {
    server_name = "Web Server 1 (AZ1)"
  }))

  # Name tag for easy identification
  tags = merge(
    local.tagging,
    {
      Name = "${var.web_server_name}-1"
      AZ   = var.availability_zones[0]
    }
  )

  # Prevent accidental termination 
  lifecycle {
    prevent_destroy = false
  }

  # Wait for instance to be ready
  depends_on = [aws_internet_gateway.main]
}


# Web Server 2 (in Public Subnet 2, AZ2)

resource "aws_instance" "web_2" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_2.id
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  associate_public_ip_address = true

  # Script to install and configure Nginx
  user_data = base64encode(templatefile("${path.module}/script.sh", {
    server_name = "Web Server 2 (AZ2)"
  }))

  # Name tag for easy identification
  tags = merge(
    local.tagging,
    {
      Name = "${var.web_server_name}-2"
      AZ   = var.availability_zones[1]
    }
  )

  # Prevent accidental destroy
  lifecycle {
    prevent_destroy = false
  }

  # Wait for instance to be ready
  depends_on = [aws_internet_gateway.main]
}
