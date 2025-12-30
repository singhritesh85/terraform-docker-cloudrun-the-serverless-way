# Create VPC in GCP
resource "google_compute_network" "cloudrun_vpc" {
  name = "${var.prefix}-vpc"
  auto_create_subnetworks = false   
}

# Create Private Subnet for VPC in GCP
resource "google_compute_subnetwork" "cloudrun_subnet" {
  name = "${var.prefix}-${var.gcp_region}-private-subnet"
  region = var.gcp_region
  network = google_compute_network.cloudrun_vpc.id 
  private_ip_google_access = true           ### VMs in this Subnet without external IP
  ip_cidr_range = "192.168.1.0/28"
}

# Create Public Subnet for VPC in GCP
resource "google_compute_subnetwork" "cloudrun_public_subnet" {
  name = "${var.prefix}-${var.gcp_region}-public-subnet"
  region = var.gcp_region
  network = google_compute_network.cloudrun_vpc.id
  ip_cidr_range = "192.168.1.16/28"
}

# Create Proxy Only Subnetwork
resource "google_compute_subnetwork" "proxy_only_subnetwork" {
  name          = "${var.prefix}-proxy-only-subnetwork"
  ip_cidr_range = "10.0.0.0/22"
  region        = var.gcp_region
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = google_compute_network.cloudrun_vpc.id
}

# Create GCP Cloud Router
resource "google_compute_router" "nat_router" {
  name    = "${var.prefix}-nat-router"
  region  = var.gcp_region
  network = google_compute_network.cloudrun_vpc.name
}

# Create GCP Cloud NAT
resource "google_compute_router_nat" "nat_gateway" {
  name                          = "${var.prefix}-nat-gateway"
  router                        = google_compute_router.nat_router.name
  region                        = google_compute_router.nat_router.region
  nat_ip_allocate_option        = "AUTO_ONLY" ### "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.cloudrun_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Create GCP Serverless VPC access Connector 
resource "google_vpc_access_connector" "vpc_access_connector" {
  name          = "${var.prefix}-connector"
  region        = var.gcp_region
  network       = google_compute_network.cloudrun_vpc.self_link
  ip_cidr_range = "192.168.1.32/28"        ###google_compute_subnetwork.cloudrun_subnet.ip_cidr_range
  machine_type  = "f1-micro"
  min_instances = 2
  max_instances = 3
}
