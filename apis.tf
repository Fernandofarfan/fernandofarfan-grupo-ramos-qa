locals {
  services = [
    "compute.googleapis.com",
    "iap.googleapis.com"
  ]
}

resource "google_project_service" "qa_apis" {
  for_each           = toset(local.services)
  project            = "gramos-sap-car-rise-qa"
  service            = each.key
  disable_on_destroy = false
}
