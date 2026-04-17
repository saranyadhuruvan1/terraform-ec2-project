sg_name        = "saranya-ec2-sg"
sg_description = "Dynamic SG for EC2"

ingress_rules = [
  {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

egress_rules = [
  {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

key_name = "saranya-key"
ami_id        = "ami-0c02fb55956c7d316"   # Amazon Linux 2 example
instance_type = "t3.micro"
ec2_name      = "saranya-ec2"
target_groups = {
  app1 = {
    name              = "saranya-app1-tg"
    port              = 80
    protocol          = "HTTP"
    health_check_path = "/app1/health"
  }

  app2 = {
    name              = "saranya-app2-tg"
    port              = 80
    protocol          = "HTTP"
    health_check_path = "/app2/health"
  }
}


