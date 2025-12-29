###################################### Parameters to be used for Cloudrun serverless Docker containers#####################################

project_name = "XXXX-XXXXXXX-2XXXX6"  ### Provide the Account Project ID
gcp_region = ["us-east1", "us-central1", "asia-south2", "asia-south1", "us-west1"]

prefix = "cloudrun"
REPO_NAME = "us-central1-docker.pkg.dev/wise-trainer-244916/bankapp"
IMAGE_NAME = "dexter"
TAG_NUMBER = "1.02"
MYSQL_ROOT_PASSWORD = "Dexter@123"
MYSQL_DATABASE = "bankappdb"
database_version = ["MYSQL_5_6", "MYSQL_5_7", "MYSQL_8_0", "POSTGRES_11", "POSTGRES_12", "POSTGRES_13", "POSTGRES_14", "POSTGRES_15"]
tier = ["db-f1-micro", "db-n1-standard-1", "db-e2-small", "db-e2-medium", "db-n2-standard-4", "db-c2-standard-4", "db-c3-standard-4"]
env = ["dev", "stage", "prod"]
