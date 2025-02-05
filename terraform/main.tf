provider "google" {
  project = var.project_id
  region  = "us-central1"
}

# standard sql instance
resource "google_sql_database_instance" "db_instance" {
  name                = var.instance_name
  region              = "us-central1"
  database_version   = var.db_version

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.db_instance.name
}

resource "null_resource" "db_setup" {
  depends_on = [google_sql_database_instance.db_instance]

  provisioner "local-exec" {
    command = var.null_resource_command
  }
}


# standard computer instance
resource "google_compute_instance" "app" {
  name         = var.app_name
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

  depends_on = [
    google_sql_database_instance.db_instance
  ]
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

