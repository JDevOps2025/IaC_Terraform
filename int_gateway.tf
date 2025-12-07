# Internet gateway configuration to enable communication between the VPC and the internet
# It is required for resources in public subnets to access the internet and for the internet to reach those resources

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-igw"
    }
  )
}