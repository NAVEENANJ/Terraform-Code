module "ecs" {
  source = "./modules/ecs"
  cpu    = var.cpu
  memory = var.memory
  #container_name=""
  container_port            = var.container_port
  host_port                 = var.host_port
  container_image           = var.container_image
  cluster_name              = aws_ecs_cluster.ecs-cluster.arn
  ecs_subnet_ids            = ["${module.dev_vpc.private_subnet_1.id}", "${module.dev_vpc.private_subnet_2.id}"]
  vpc_id                    = module.dev_vpc.vpc_id.id
  target_group_health_check = var.target_group_health_check
  alb_security_group_id     = module.alb_sg.security_group_id.id
  alb_listener_arn          = module.alb.alb_listener_arn.arn

  alb_path_based_listener = "/*"
  ProjectName             = var.ProjectName
  servicename             = var.servicename
  environment             = var.environment
  region                  = var.region
  #cidr_blocks=

  #For IAM Additional Permission
  #additional_permissions=["ec2:*","s3:*"]
  #resource_arn=["arn:aws:elasticloadbalancing:us-east-1:accout-id:arn"]

  #For Autoscaling Configuration

  #   desired_count=1
  # max_capacity=1
  # min_capacity=1
  # cpu_target_value=75
  #  memory_target_value=75
  # cpu_scale_in_cooldown=200
  # memory_scale_in_cooldown=200
  # cpu_scale_out_cooldown=200
  # memory_scale_out_cooldown=200


  depends_on = [
    module.alb
  ]
}
