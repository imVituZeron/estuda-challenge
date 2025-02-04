provider "google" {
  project = "careful-memory-449901-f9"
  region  = "us-central1"
}

# standard computer instance
resource "google_compute_instance" "app" {
  name         = "estuda-app"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    
    }
  }

  # metadata = {
  #   "items" = [
  #     "ssh Keys",
  #     "ssh-publickey ${aws_key_pair.example.public_key}"
  #   ]
  # }
}

# resource "google_compute Firewall Rule" "example" {
#   name    = "example-rule"
#   network = google_compute_network.example.name
#   target  = [google_compute_instance.example.self_link]
#   allow {
#     protocol = "tcp"
#     ports   = ["22", "80"]
#   }

#   source_ranges = ["0.0.0.0/0"]
# }

# resource "google_compute_network" "example" {
#   name        = "example-network"
#   subnets    = ["30.105.0.0/24"]
#   auto_create_subnets = true
# }

# standard sql instance
resource "google_sql_database_instance" "sql_instance" {
  name                = "estuda"
  region              = "us-central1"
  database_version   = "MYSQL_8_0"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = "estuda_clients"
  instance = google_sql_database_instance.sql_instance.name
}

