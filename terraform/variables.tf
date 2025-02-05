variable "app_name" {
  description = "app name"
  type        = string
  default     = "estuda-app"
}

variable "project_id" {
  description = "project id"
  type        = string
  default     = "careful-memory-449901-f9"
}

variable "instance_name" {
  description = "sql instance name"
  type        = string
  default     = "estuda"
}

variable "db_version" {
  description = "database instance type"
  type        = string
  default     = "MYSQL_8_0"
}

variable "database_name" {
  description = "sql database name"
  type        = string
  default     = "estuda_clients"
}

variable "null_resource_command" {
  description = "null resource command"
  type        = string
  default     = "sh db_setup.sh 0.0.0.0 root bi7d2lyFNV9ZwjB3 estuda_clients"
}


