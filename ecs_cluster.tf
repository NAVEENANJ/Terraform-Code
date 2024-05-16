resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.ProjectName}-ecs-cluster-${var.environment}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    environment = var.environment

  }

}