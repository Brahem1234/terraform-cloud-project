variable "name_prefix" { type = string }
variable "force_destroy" {
  type    = bool
  default = false
}
variable "noncurrent_expiration_days" {
  type    = number
  default = 30
}