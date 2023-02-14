resource "aws_instance" "instance_1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello world 1" > index.html
              python3 -m http.server 8080 &
              EOF
  tags = {
    Name = "${var.environment_name}-instance-1"
  }
}

resource "aws_instance" "instance_2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello world 2" > index.html
              python3 -m http.server 8080 &
              EOF
              
  tags = {
    Name = "${var.environment_name}-instance-2"
  }
}