## Print the DB password for future refernce

output "db_password" {
  value = random_password.Development_rds.result
  description = "db password"
}

### Print the DB hostname

output "db_hostname" {
    value = aws_db_instance.Development_rds_instance.address
    description = "DB Hostname"
  
}

output "db_port" {
  value = aws_db_instance.Development_rds_instance.port
}

output "db_url" {
  value = "jdbc:mysql://${aws_db_instance.Development_rds_instance.address}/${var.username}"
}