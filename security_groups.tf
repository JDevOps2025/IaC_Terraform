# Security groups configuration to control inbound and outbound traffic to/from resources with separate groups for ALB and web servers


# Application load balancer security group to allows HTTP/HTTPS traffic from the internet

resource "aws_security_group" "alb" {
  count = var.enable_alb ? 1 : 0

  name_prefix = "${local.project_name}-alb-sg-"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP (port 80) from anywhere
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr
  }

  # Allow HTTPS (port 443) from anywhere
  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_cidr
  }

  # Allow all outbound traffic (to communicate with web servers and internet)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-alb-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}


# Web-Servers security group to allow traffic from the ALB (HTTP/HTTPS) and SSH for management 

resource "aws_security_group" "web_server" {
  name_prefix = "${local.project_name}-web-sg-"
  description = "Security group for web server instances"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP (port 80) from ALB or
  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = var.enable_alb ? [aws_security_group.alb[0].id] : []
    cidr_blocks     = !var.enable_alb ? ["0.0.0.0/0"] : null
  }

  # Allow HTTPS (port 443) from ALB
  ingress {
    description     = "Allow HTTPS from ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = var.enable_alb ? [aws_security_group.alb[0].id] : []
    cidr_blocks     = !var.enable_alb ? ["0.0.0.0/0"] : null
  }

  # Allow SSH (port 22) for management
  ingress {
    description = "Allow SSH for management"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tagging,
    {
      Name = "${local.project_name}-web-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}