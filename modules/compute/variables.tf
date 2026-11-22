variable "name_prefix" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "instance_profile_name" { type = string }
variable "target_group_arn" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "min_size" {
  type = number
  validation {
    condition     = var.min_size >= 2
    error_message = "min_size doit être >= 2 (haute disponibilité)."
  }
}
variable "max_size" {
  type = number
}
variable "desired_capacity" {
  type    = number
  default = null
}