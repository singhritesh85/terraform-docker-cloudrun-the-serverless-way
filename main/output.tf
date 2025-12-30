output "Details_for_cloud_run_bankapp_alb_public_ip_and_cloud_sql" {
  description = "Details of the GCP Cloud Run BankApp and Cloud Run MySQL"
  value       = "${module.cloudrun}"
}
