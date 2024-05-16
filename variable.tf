# VPC Variables
variable "ProjectName" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "pri_sub_1_cidr" {
  type = string

}

variable "pri_sub_2_cidr" {
  type = string

}
variable "pub_sub_1_cidr" {
  type = string

}
variable "pub_sub_2_cidr" {
  type = string

}

variable "region" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "cpu" {
  type = number
}
variable "memory" {
  type = number
}

variable "container_port" {
  description = "Port of the ecs container"
  type        = number
}

variable "host_port" {
  type = number
}

variable "container_image" {
  description = "Image name for docker task"
  type        = string
}

variable "target_group_health_check" {
  description = "Health check path for target group"
  type        = string
}

variable "alb_path_based_listener" {
  description = "Add this variables for the path based listener in alb"
  type        = string
}
variable "servicename" {
  type = string
}