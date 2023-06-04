variable "service_account_id" {
  description = "SA for GKE"
  type        = string
}

variable "service_account_name" {
  description = "SA for GKE"
  type        = string
}

variable "service_account" {
  description = "SA for GKE"
  type        = string
}

variable "gke_name" {
  description = "Name of the GKE Cluster"
  type        = string
}

variable "gke_project" {
  description = "Name of the GKE Cluster"
  type        = string
}
variable "gke_location" {
  description = "Geo Location of the GKE Cluster"
  type        = string
}

variable "service_account_project" {
  description = "Project of the GKE Cluster"
  type        = string
}

variable "pods_subnet_name" {
  description = "GKE Pods Subnet"
  type        = string
}

variable "service_subnet_name" {
  description = "GKE Services Subnet"
  type        = string
}

variable "gke_vpc" {
  description = "GKE VPC"
  type        = string
}

variable "gke_nodes_subnet" {
  description = "GKE Nodes Subnet"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "Master Control Plane Subnet"
  type        = string
}

variable "cidr_block" {
  default = []
  type    = list(string)
}

variable "display_name" {
  description = "Master Control Plane Subnet"
  type        = string
}

#variable "node_zones" {
#  description = "Location of GKE Nodes"
#  type        = list(string)
#}

variable "node_pool" {
  description = "Cloud DNS Private Zone"
  type = map(object({
    project        = string
    node_pool_name = string
    location       = string
    node_zones     = list(string)
    gke_cluster    = string
    node_count     = number
    disk_type      = string
    disk_size      = number
    machine_type   = string
  }))
}

variable "oauth_scopes" {
  default = []
  type    = list(string)
}
