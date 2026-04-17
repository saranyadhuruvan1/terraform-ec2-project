provider "aws" {
  region = "us-east-1"
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
module "ec2_sg" {
  source      = "../../modules/ec2_sg"

  name        = var.sg_name
  description = var.sg_description
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}
module "keypair" {
  source   = "../../modules/keypair"
  key_name = var.key_name
}
module "ec2" {
  source = "../../modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  name              = var.ec2_name

  # ⭐ Use default subnet
  subnet_id         = data.aws_subnets.default.ids[0]

  # ⭐ Attach SG from SG module
  security_group_id = module.ec2_sg.security_group_id

  # ⭐ Attach keypair from keypair module
  key_name          = module.keypair.key_name
}
module "target_groups" {
  for_each = var.target_groups
  source   = "../../modules/target_group"

  name              = each.value.name
  port              = each.value.port
  protocol          = each.value.protocol
  vpc_id            = data.aws_vpc.default.id
  health_check_path = each.value.health_check_path
}

resource "aws_lb_target_group_attachment" "attach" {
  for_each = var.target_groups

  target_group_arn = module.target_groups[each.key].target_group_arn
  target_id        = module.ec2.instance_id
  port             = each.value.port
}
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "alb_sg" {
  source = "../../modules/alb_sg"
  vpc_id = data.aws_vpc.default.id
}
module "alb" {
  source = "../../modules/alb"

  name            = "saranya-alb"
  security_groups = [module.alb_sg.id]
  subnets         = data.aws_subnets.public.ids
}

resource "aws_lb_listener_rule" "rules" {
  for_each = var.target_groups

  listener_arn = module.alb.listener_arn
  priority     = 100 + index(keys(var.target_groups), each.key)

  action {
    type             = "forward"
    target_group_arn = module.target_groups[each.key].target_group_arn
  }

  condition {
    path_pattern {
      values = ["/${each.key}/*"]
    }
  }
}


