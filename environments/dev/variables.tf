
variable "sg_name" {
  type = string
}

variable "sg_description" {
  type = string
}

variable "ingress_rules" {
  type = list(any)
}

variable "egress_rules" {
  type = list(any)
}
variable "key_name" {
  type = string
}
variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ec2_name" {
  type = string
}
variable "target_groups" {
  type = map(object({
    name              = string
    port              = number
    protocol          = string
    health_check_path = string
  }))
}





