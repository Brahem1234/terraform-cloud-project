variable "name_prefix" {
  type        = string
  description = "Préfixe <projet>-<env>"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR du VPC"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr doit être un CIDR valide."
  }
}
variable "azs" {
  type        = list(string)
  description = "Zones de disponibilité (min 2)"
  validation {
    condition     = length(var.azs) >= 2
    error_message = "Au moins deux zones de disponibilité."
  }
}
variable "public_subnet_cidrs" { type = list(string) }
variable "app_subnet_cidrs" { type = list(string) }
variable "db_subnet_cidrs" { type = list(string) }
variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "true = 1 NAT (économique), false = 1 NAT par AZ (haute dispo)"
}