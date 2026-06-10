terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "gramos-sap-car-rise-qa"
}

module "compute" {
  source         = "./modules/compute"
  qa_project     = "gramos-sap-car-rise-qa"
  desired_status = var.desired_status
  zone           = var.zone
}
