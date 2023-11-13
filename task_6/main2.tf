provider "google" {
  project = "savvy-arbor-401520"
  region  = "us-central1"
  zone    = "us-central1-c"
}
resource "google_compute_instance" "dare-id-vm" {
  name         = "dareit-vm-tf1"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["dareit"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        managed_by_terraform = "true"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.bucket.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket" "bucket" {
  name     = "icandothis1"
  location = "EU"
}

resource "google_sql_database" "database" {
  name     = "dareit2"
  instance = google_sql_database_instance.instance.name
}


resource "google_sql_database_instance" "instance" {
  name             = "my-database-instance"
  region           = "us-central1"
  database_version = "POSTGRES_15"
  settings {
    tier = "db-f1-micro"
  }

}



resource "google_sql_user" "users" {
  name     = "dareit_user"
  instance = google_sql_database_instance.instance.name
  password = "changeme"
}