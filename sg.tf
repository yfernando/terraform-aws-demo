resource "aws_security_group" "CM_ecs_sg" {
    name   = "CM-ecs-sg"
    vpc_id = aws_vpc.CM_main.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "CM-ecs-sg"
    }
}