#output "service_uri_bankapp" {
#  description = "The auto-generated URI of the deployed BankApp Cloud Run service"
#  value       = google_cloud_run_v2_service.cloudrun_bankapp.uri
#}

output "db_connection_name" {
  description = "Cloud SQL database connection name"
  value = google_sql_database_instance.db_instance.connection_name
}

output "db_instance_private_ip_address" {
  description = "Cloud SQL DB Instance private IP Address"
  value = google_sql_database_instance.db_instance.private_ip_address
}

output "gcp_alb_public_ip" {
  description = "The public IP address of the GCP Application Load Balancer"
  value       = google_compute_forwarding_rule.cloudrun_forwarding_rule_443.ip_address
}
