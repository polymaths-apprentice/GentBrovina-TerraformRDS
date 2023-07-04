provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

# Create VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnet for the Bastion host
resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.example.id
}

# Create private subnet for RDS instance
resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.example.id
}

# Create security group for RDS instance
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds_sg"

  ingress {
    description = "MySQL/Aurora inbound"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create RDS instance
resource "aws_db_instance" "example" {
  identifier                = "example-db"
  engine                    = "mysql"  # Replace with your desired database engine (e.g., "mysql" or "aurora")
  instance_class            = "db.t2.micro"
  allocated_storage         = 20
  ersion            = "5.7"
  usernastorage_type              = "gp2"
  engine_vme                  = "admin"
  password                  = "Password123!"  # Replace with your desired password
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  publicly_accessible       = false
  multi_az                  = false
  backup_retention_period   = 7
  skip_final_snapshot       = true
}

# Output RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.example.endpoint
}
