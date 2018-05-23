data "aws_ecs_task_definition" "nginx" {
  task_definition = "${aws_ecs_task_definition.nginx.family}"
  depends_on      = ["aws_ecs_task_definition.nginx"]
}

resource "aws_ecs_task_definition" "nginx" {
  family = "nginx-app-static"

  container_definitions = <<DEFINITION
[
    {
                "name": "nginxhello",
                "image": "easkerov/nginxhello",
                "cpu": 10,
                "memory": 300,
                "essential": true,
                "portMappings": [
                    {
                        "hostPort": 80,
                        "containerPort": 80,
                        "protocol": "tcp"
                    }
                ],
                "links": [],
                "command": [],
                "entryPoint": [],
                "environment": [],
                "mountPoints": []
    }
]
DEFINITION
}
