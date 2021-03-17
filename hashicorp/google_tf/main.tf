terraform {
  required_version = ">= 0.13"
}

#Google
module "Cluster_GKE" {
  source = "./Cluster_GKE"
  cluster_name = "gs-google-gke"
  credentials_file = var.credentials_file
}