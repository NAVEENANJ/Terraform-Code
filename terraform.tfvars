#VPC Varaibles
cidr_block     = "10.10.0.0/16"
pri_sub_1_cidr = "10.10.1.0/24"
pri_sub_2_cidr = "10.10.3.0/24"
pub_sub_1_cidr = "10.10.2.0/24"
pub_sub_2_cidr = "10.10.4.0/24"
ProjectName    = "demo"
environment    = "test"
region         = "ap-south-1"


#ECS 
cpu                       = 256
memory                    = 512
container_port            = 5000
host_port                 = 5000
container_image           = "nginx"
target_group_health_check = "/api/data"
alb_path_based_listener   = "/*"
servicename               = "node-application"
