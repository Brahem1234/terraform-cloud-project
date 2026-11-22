variable "aws_region" {
  type    = string
  default = "eu-north-1"
}
variable "project_name" {
  type    = string
  default = "cloud5"
}
variable "owner" {
  type    = string
  default = "ala"
}
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment doit valoir dev, test ou prod."
  }
}
variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}
variable "app_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.11.0/24", "10.20.12.0/24"]
}
variable "db_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.21.0/24", "10.20.22.0/24"]
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "min_size" {
  type    = number
  default = 2
}
variable "max_size" {
  type    = number
  default = 4
}
variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "single_nat_gateway" {
  type    = bool
  default = true
}
variable "db_multi_az" {
  type    = bool
  default = false
}
variable "force_destroy_bucket" {
  type    = bool
  default = true
}