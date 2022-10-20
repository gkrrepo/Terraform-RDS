variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "db_password" {
  default = "Postgres12345"
  description = "RDS root user password"
  sensitive   = true
}

variable "db_username" {
  default = "postgres"
  description = "RDS root user name"
  sensitive   = true
}