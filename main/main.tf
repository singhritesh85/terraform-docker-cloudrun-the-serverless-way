module "cloudrun" {

source = "../module"
gcp_region = var.gcp_region[1]
project_name = var.project_name
prefix = var.prefix
REPO_NAME = var.REPO_NAME
IMAGE_NAME = var.IMAGE_NAME
TAG_NUMBER = var.TAG_NUMBER
MYSQL_ROOT_PASSWORD = var.MYSQL_ROOT_PASSWORD
MYSQL_DATABASE = var.MYSQL_DATABASE
database_version = var.database_version[2]
tier = var.tier[0]
env = var.env[0]

}
