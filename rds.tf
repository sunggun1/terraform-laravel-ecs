resource "aws_db_subnet_group" "mysqldb-subnet"{
    name = "mysqldb-subnet"
    description = "RDS subnet group"
    subnet_ids = module.vpc.private_subnets
}

resource "aws_db_parameter_group" "mysql-parameters"{
    name = "mysqldb-parameters"
    family = "mysql5.7"
    description = "mysqlDB parameter group"

    parameter {
        name  = "max_allowed_packet"
        value = "16777216"
    }
}

resource "aws_security_group" "allow-mysqldb"{
    vpc_id = module.vpc.vpc_id
    name = "allow-mysqldb"
    description = "allow-mysqldb"

    ingress{
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.ecs-demo.id]
    }

    egress{
        from_port = 0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow-mysqldb"
    }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 100
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "db"
  username             = "username"
  password             = "password"
  db_subnet_group_name    = aws_db_subnet_group.mysqldb-subnet.name
  parameter_group_name    = aws_db_parameter_group.mysql-parameters.name
  multi_az                = "false" # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = [aws_security_group.ecs-demo.id]
  storage_type            = "gp2"
  backup_retention_period = 30                                          # how long you’re going to keep your backups
  availability_zone       = data.aws_availability_zones.available.names[0] # prefered AZ
  skip_final_snapshot     = true                                        # skip final snapshot when doing terraform destroy
  tags = {
    Name = "mysqldb-instance"
  }
}