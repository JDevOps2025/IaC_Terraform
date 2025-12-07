# NAT gateway configuration to allow instances in private subnets outbound traffic to the internet while remaining blocked from the internet

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-nat-eip"
    }
  )

  # Block accidental deletion
  lifecycle {
    prevent_destroy = false
  }
}

# NAT gateway in public subnet 1
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id # Must be a public subnet
  depends_on    = [aws_internet_gateway.main]

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-nat-gw"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}