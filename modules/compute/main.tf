data "google_compute_network" "qa_vpc" {
  name    = "gramos-vpc-shared-dev"
  project = "gramos-prj-dev-shd-net-01"
}

data "google_compute_subnetwork" "qa_subnet" {
  name    = "gramos-shared-sap-dev-01"
  region  = "us-east1"
  project = "gramos-prj-dev-shd-net-01"
}

# -------------------------------------------------------------------------
# INSTANCIA 1: SAP CAR APP QA (vhgrrcaqapp01)
# -------------------------------------------------------------------------
resource "google_compute_instance" "sap_car_app_qa" {
  name         = "vhgrrcaqapp01"
  machine_type = "n2d-highmem-8"
  zone         = var.zone
  project      = var.qa_project
  tags         = ["allow-iap", "sap-app", "sap-vm"]
  desired_status = var.desired_status

  boot_disk {
    initialize_params {
      image = "suse-sap-cloud/sles-15-sp7-sap"
      size  = 64
      type  = "hyperdisk-balanced"
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.qa_subnet.self_link
    network_ip = "10.79.20.10"
  }

  lifecycle {
    ignore_changes = [boot_disk, attached_disk]
  }
}

resource "google_compute_disk" "sap_car_app_qa_sap_disk" {
  name    = "vhgrrcaqapp01-sap-disk"
  type    = "hyperdisk-balanced"
  size    = 512
  zone    = var.zone
  project = var.qa_project
  lifecycle { prevent_destroy = true }
}

resource "google_compute_attached_disk" "sap_car_app_qa_sap_disk_attach" {
  disk     = google_compute_disk.sap_car_app_qa_sap_disk.id
  instance = google_compute_instance.sap_car_app_qa.id
  zone     = var.zone
  project  = var.qa_project
}

# -------------------------------------------------------------------------
# INSTANCIA 2: SAP CAR DB HANA QA (vhgrrcaqdb01)
# -------------------------------------------------------------------------
resource "google_compute_instance" "sap_car_db_qa" {
  name         = "vhgrrcaqdb01"
  machine_type = "m3-ultramem-64"
  zone         = var.zone
  project      = var.qa_project
  tags         = ["allow-iap", "sap-db", "sap-vm"]
  desired_status = var.desired_status

  boot_disk {
    initialize_params {
      image = "suse-sap-cloud/sles-15-sp7-sap"
      size  = 64
      type  = "hyperdisk-balanced"
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.qa_subnet.self_link
    network_ip = "10.79.20.11"
  }

  lifecycle {
    ignore_changes = [boot_disk, attached_disk]
  }
}

# Partición 2: /usr/sap (260 GB)
resource "google_compute_disk" "db_sap_disk" {
  name    = "vhgrrcaqdb01-sap-disk"
  type    = "hyperdisk-balanced"
  size    = 260
  zone    = var.zone
  project = var.qa_project
  lifecycle { prevent_destroy = true }
}

resource "google_compute_attached_disk" "db_sap_disk_attach" {
  disk     = google_compute_disk.db_sap_disk.id
  instance = google_compute_instance.sap_car_db_qa.id
  zone     = var.zone
  project  = var.qa_project
}

# Partición 3: /hana/data (8956 GB)
resource "google_compute_disk" "db_hana_data_disk" {
  name    = "vhgrrcaqdb01-hana-data-disk"
  type    = "hyperdisk-balanced"
  size    = 8956
  zone    = var.zone
  project = var.qa_project
  lifecycle { prevent_destroy = true }
}

resource "google_compute_attached_disk" "db_hana_data_disk_attach" {
  disk     = google_compute_disk.db_hana_data_disk.id
  instance = google_compute_instance.sap_car_db_qa.id
  zone     = var.zone
  project  = var.qa_project
}

# Partición 4: /hana/log (512 GB)
resource "google_compute_disk" "db_hana_log_disk" {
  name    = "vhgrrcaqdb01-hana-log-disk"
  type    = "hyperdisk-balanced"
  size    = 512
  zone    = var.zone
  project = var.qa_project
  lifecycle { prevent_destroy = true }
}

resource "google_compute_attached_disk" "db_hana_log_disk_attach" {
  disk     = google_compute_disk.db_hana_log_disk.id
  instance = google_compute_instance.sap_car_db_qa.id
  zone     = var.zone
  project  = var.qa_project
}

# Partición 5: /hana/shared (1024 GB)
resource "google_compute_disk" "db_hana_shared_disk" {
  name    = "vhgrrcaqdb01-hana-shared-disk"
  type    = "hyperdisk-balanced"
  size    = 1024
  zone    = var.zone
  project = var.qa_project
  lifecycle { prevent_destroy = true }
}

resource "google_compute_attached_disk" "db_hana_shared_disk_attach" {
  disk     = google_compute_disk.db_hana_shared_disk.id
  instance = google_compute_instance.sap_car_db_qa.id
  zone     = var.zone
  project  = var.qa_project
}

# Partición 6: /backup (6144 GB)
resource "google_compute_disk" "db_backup_disk" {
  name    = "vhgrrcaqdb01-backup-disk"
  type    = "hyperdisk-balanced"
  size    = 6144
  zone    = var.zone
  project = var.qa_project
  lifecycle { prevent_destroy = true }
}

resource "google_compute_attached_disk" "db_backup_disk_attach" {
  disk     = google_compute_disk.db_backup_disk.id
  instance = google_compute_instance.sap_car_db_qa.id
  zone     = var.zone
  project  = var.qa_project
}
