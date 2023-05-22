resource "aws_ecs_cluster" "CM_ecs_cluster" {
  name = "CM-ecs-cluster"
  tags = {
    Name      = "CM-ecs-cluster"
    CreatedBy = "yfernando"
  }
}

resource "aws_ecs_task_definition" "CM_ecs_task" {
  family                   = "web-server"
  execution_role_arn       = aws_iam_role.CM_task_execution_role.arn
  task_role_arn            = aws_iam_role.CM_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions = file("container_definitions/container_def.json")
}

resource "aws_ecs_service" "CM_ecs_service" {
  name                                = "web-service"
  cluster                             = aws_ecs_cluster.CM_ecs_cluster.id
  task_definition                     = aws_ecs_task_definition.CM_ecs_task.arn
  desired_count                       = 2
  deployment_minimum_healthy_percent  = 50
  deployment_maximum_percent          = 200
  launch_type                         = "FARGATE"
  scheduling_strategy                 = "REPLICA"

  count = length(var.private_subnets)
  network_configuration {
    security_groups   = [aws_security_group.CM_ecs_sg.id]
    subnets           = [aws_subnet.CM_subnet_private[count.index].id] # needs fixing as only takes the first subnet
    assign_public_ip  = false
  }
}

