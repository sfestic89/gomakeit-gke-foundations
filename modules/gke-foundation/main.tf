resource "google_service_account" "default" {
  project      = var.service_account_project
  account_id   = var.service_account_id
  display_name = var.service_account_name
}

resource "google_container_cluster" "primary" {
  project  = var.gke_project
  name     = var.gke_name
  location = var.gke_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # GKE Network
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_subnet_name
    services_secondary_range_name = var.service_subnet_name
  }
  network    = var.gke_vpc
  subnetwork = var.gke_nodes_subnet
  
  # GKE Logging and Monitoring 
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  maintenance_policy {
    daily_maintenance_window {
      start_time = "02:00"
    }
  }

  # Create Private GKE Cluster
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.cidr_block
    content {
      cidr_blocks {
        cidr_block   = master_authorized_networks_config.value
        display_name = var.display_name
      }
    }
  }

  # GKE Version 
  release_channel {
    channel = "STABLE"
  }

  # Enable network Policy (Calico)
  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  /* Enable network policy configurations (like Calico).
  For some reason this has to be in here twice. */
  network_policy {
    enabled = "false"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  for_each = { for name, node_pool in var.node_pool : name => node_pool }

  project        = each.value.project
  name           = each.value.node_pool_name
  cluster        = each.value.gke_cluster
  node_count     = each.value.node_count
  location       = each.value.location
  node_locations = each.value.node_zones #var.node_zones

  node_config {
    preemptible  = true
    disk_size_gb = each.value.disk_size
    disk_type    = each.value.disk_type
    machine_type = each.value.machine_type

    service_account = var.service_account
    oauth_scopes    = var.oauth_scopes
  }
  autoscaling {
    max_node_count = 1
    min_node_count = 1
  }
  max_pods_per_node = 100

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 1
  }
}
