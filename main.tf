resource "aws_db_subnet_group" "development-db-subnet-grp" {
  name        = "development-db-sgrp"
  description = "Database Subnet Group"
  type        = "list"
  subnet_ids  = aws_subnet.private.*.id  ## Mention it as list
}

resource "aws_security_group" "rds" {
  name   = "Development_rds"
  vpc_id = vpc.id   ##denote the vpc id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Development_rds"
  }
}

#resource "aws_db_parameter_group" "Development_rds_parameter" {
#  name   = "Development_rds_parameter"
#  family = "postgres13"
#
# parameter {
#    name  = "log_connections"
#    value = "1"
#  }
#}

resource "aws_db_instance" "Development_rds_instance" {
  identifier             = "Development_rds_instance"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  max_allocated_storage  = 70
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = var.db.username
  password               = data.aws_secretsmanager_secret_version.password
  port                   = 5432
  storage_encrypted      = true
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.development-db-subnet-grp.name
  vpc_security_group_ids = [aws_security_group.rds.id]
 # parameter_group_name   = aws_db_parameter_group.Development_rds_parameter.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  backup_window          = "03:00-06:00"
  maintenance_window     = "Mon:00:00-Mon:03:00"
  multi_az               =  true
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  deletion_protection         = true
}


#### data "local_file" "sql_script" {
####  filename = "${path.module}/db.sql"
#### }
####resource "null_resource" "setup_db" {
####  depends_on = [aws_db_instance.Development_rds_instance]
####  provisioner "local-exec" {
####    command = "mysql -u ${var.db_username} -p${var.db_password} -h ${aws_db_instance.Development_rds_instance.address} < ${data.local_file.sql_script.content}"
####  }
####}

### To get the secret from AWS Secret Manager

data "aws_secretsmanager_secret" "password" {
  name = "Development_rds_password"

}

data "aws_secretsmanager_secret_version" "password" {
  secret_id = data.aws_secretsmanager_secret.password
}

## Print the DB password for future refernce

output "db_password" {
  value = random_password.Development_rds.result
  description = "db password"
}
