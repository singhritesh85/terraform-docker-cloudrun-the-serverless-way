#resource "google_service_account" "cloudrun_service_account" {
#  account_id   = "${var.prefix}-service-account"
#  display_name = "Custom Service Account for Cloud Run"
#}

#resource "google_project_iam_member" "service_account_run_invoker" {
#  project = var.project_name
#  role    = "roles/run.invoker"
#  member  = "allUsers"    ###"serviceAccount:${google_service_account.cloudrun_service_account.email}"
#}

resource "google_cloud_run_v2_service" "cloudrun_bankapp" {
  name     = "${var.prefix}-bankapp"
  location = var.gcp_region 
  deletion_protection = false
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"     ###"INGRESS_TRAFFIC_INTERNAL_ONLY"       ###"INGRESS_TRAFFIC_ALL"
  default_uri_disabled = true                      ###false

  template {
    health_check_disabled = false
    max_instance_request_concurrency = 80
    timeout = "300s"
#    service_account = google_service_account.cloudrun_service_account.email
    containers {
      name = "${var.prefix}-bankapp"
      image = "${var.REPO_NAME}/${var.IMAGE_NAME}:${var.TAG_NUMBER}"
      ports {
        container_port = 8080
      }
      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
      env {
        name  = "JDBC_URL"
        value = "jdbc:mysql://${google_sql_database_instance.db_instance.private_ip_address}:3306/bankappdb?useSSL=false&serverTimezone=UTC"
      }
      env {
        name  = "JDBC_PASS"
        value = "Admin123"
      }
      env {
        name  = "JDBC_USER"
        value = "dbadmin"
      }
      liveness_probe {
        initial_delay_seconds = 60
        timeout_seconds       = 1
        period_seconds        = 30
        failure_threshold     = 3
        http_get {
          port = 8080
          path = "/login"
        }
      }
      startup_probe { 
        initial_delay_seconds = 60
        timeout_seconds       = 1
        period_seconds        = 30
        failure_threshold     = 3
        http_get {
          port = 8080
          path = "/login"
        }
      }
    }
    scaling {
      min_instance_count = 1
      max_instance_count = 3
    }
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.db_instance.connection_name]
      }
    }
    vpc_access {
      connector = google_vpc_access_connector.vpc_access_connector.id
      egress    = "ALL_TRAFFIC" 
    }
  }
  traffic {
    type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
  depends_on = [google_sql_database_instance.db_instance]
}

resource "google_cloud_run_v2_service_iam_binding" "binding" {
  location = google_cloud_run_v2_service.cloudrun_bankapp.location 
  name = google_cloud_run_v2_service.cloudrun_bankapp.name
  role = "roles/run.invoker"   ###"roles/run.admin"  ###"roles/invoker"
  members = [
    "allUsers",
  ]
}
