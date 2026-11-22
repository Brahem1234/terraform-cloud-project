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
variable "github_repo" {
  type        = string
  description = "owner/repo autorisé à assumer les rôles"
  default     = "Brahem1234/terraform-cloud-project"
}