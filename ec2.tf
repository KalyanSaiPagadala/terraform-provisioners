

resource "aws_instance" "web" {
    ami           = data.aws_ami.centos8.id # devops-practice
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    
    tags = {
        Name = "provisioner" # instance name
    }

    provisioner "local-exec" {
        command = "echo The servers IP address is ${self.private_ip}" # self = aws_instance.web
    }

    provisioner "local-exec" {
        command = "echo ${self.private_ip} > inventory " 
    }

    # provisioner "local-exec" {
    #     command = " ansible-playbook -i inventory web.yaml" 
    # }

    connection {
        type     = "ssh"
        user     = "centos"
        password = "DevOps321"
        host     = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "echo 'this is remote exec'",
            "sudo yum install nginx -y",
            "sudo systemctl start nginx",
            
        ]
    }
}

resource "aws_security_group" "demo-sg" { 
  name        =   " provisioner" # this is for  aws
  

  ingress {
    description      = "allow all ports"
    from_port        = 22 # 0 means allows all ports
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
   ingress {
    description      = "allow all ports"
    from_port        = 80 # 0 means allows all ports
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "provisioner -sg"
  }
}

