# Routing tables configuration to control how network traffic is directed within the VPC with separate route tables for public and private subnets

# Public route table -> All traffic (0.0.0.0/0) → Internet gateway allowing instances to communicate with the internet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # This allow instances to communicate with the internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-public-rt"
      Type = "Public"
    }
  )
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}


# Private routing table to directs outbound internet traffic to the NAT Gateway
# Instances in private subnets allowed outbound connections but inbound connections from the internet blocked

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # This allows instances to access the internet for updates while staying private
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-private-rt"
      Type = "Private"
    }
  )
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
