variable "project_name" {
  description = "Provide the project name for GCP Account"
  type = string
}
variable "gcp_region" {
  description = "Provide the GCP Region in which Resources to be created"
  type = list
}

variable "prefix" {
  description = "Provide the prefix name for the GCP Resources to be created"
  type = string
}
variable "REPO_NAME" {
  description = "GCP Artifact Registry URL"
  type = string
}
variable "IMAGE_NAME" {
  description = "Provide the Docker Image Name to be created in the GCP Artifact Registry"
  type = string
}
variable "TAG_NUMBER" {
  description = "Provide the Tag Number for Docker Image to be created in the GCP Artifact Registry"
  type = string
}
variable "MYSQL_ROOT_PASSWORD" {
  description = "Provide the MySQL Root Password"
  type = string
}
variable "MYSQL_DATABASE" {
  description = "Provide the MySQL Database Name"
  type = string
}
variable "database_version" {
  description = "Provide the database version DB Instance"
  type = list
}
variable "tier" {
  description = "Provide the Machine Type for VM Instances"
  type = list
}

variable "env" {
  description = "Provide the Environment Name into which the resources to be created"
  type = list
}
