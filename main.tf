locals {
  name = "list-${var.name1}-${var.name2}-${var.name3}"
}


resource "google_compute_instance" "default" {
#   count = "${length(var.name_count)}"
    count = "${var.machine_count}"
#   name = "my-instance-${count.index+1}"
    name = "${local.name}"
    machine_type = "${var.machine_type}"
    zone = "${var.zone}"
#   can_ip_forward = "false"
    description = "This is my Virtual machine"

    tags = ["allow-http", "allow-https"]   #FIREWALL
   
#   tags = ["dev","test" ]
    boot_disk {
      initialize_params {
          image = "${var.image2}"
          size = "20"
      }
    }

    labels = {
      "name" = "list-${count.index+1}"
      machine_type = "${var.environment == "production" ? var.machine_type : var.machine_type_dev}"
    }
  

network_interface {
    network = google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.default.self_link
}



service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
}

}

resource "google_compute_disk" "default" {
  name = "test-disk"
  type = "pd-ssd"
  zone = "europe-west2-a"
  size = "20"
}

resource "google_compute_attached_disk" "default" {
  disk = "${google_compute_disk.default.self_link}"
  instance = "${google_compute_instance.default[0].self_link}"
  
}
// Forwarding rule for Internal Load Balancing
resource "google_compute_forwarding_rule" "default" {
  name   = "website-forwarding-rule"
  region = "europe-west2"

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.backend.id
  all_ports             = true
  network               = google_compute_network.default.name
  subnetwork            = google_compute_subnetwork.default.name
}

resource "google_compute_region_backend_service" "backend" {
  name          = "website-backend"
  region        = "europe-west2"
  health_checks = [google_compute_health_check.hc.id]
}

resource "google_compute_health_check" "hc" {
  name               = "check-website-backend"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold = 3
  unhealthy_threshold = 10

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_network" "default" {
  name                    = "website-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "website-net"
  ip_cidr_range = "10.0.0.0/16"
  region        = "europe-west2"
  network       = google_compute_network.default.id
}