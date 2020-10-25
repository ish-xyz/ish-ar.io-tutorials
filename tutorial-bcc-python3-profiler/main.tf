variable "ssh_user" {
  type    = string
  default = "demo-user"
}

variable "demo_dir" {
  type    = string
  default = "ish-ar.io-demo"
}

data "template_file" "bootstrap" {
  template = file("templates/bootstrap.sh.tpl")
  vars = {
    public_key = tls_private_key.demo-instance.public_key_openssh
    ssh_user   = var.ssh_user
    demo_dir   = var.demo_dir
  }
}

resource "tls_private_key" "demo-instance" {
  algorithm = "RSA"
}

resource "local_file" "pem_key" {
  content         = tls_private_key.demo-instance.private_key_pem
  filename        = "${var.ssh_user}.pem"
  file_permission = 0600
}

resource "google_compute_instance" "demo-instance" {
  name         = "ish-ar-demo-bcc"
  machine_type = "n1-standard-1"
  zone         = "europe-west2-c"

  tags = [
    "ish-ar-io-demo",
    "bcc-profiler"
  ]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-8"
    }
  }

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = data.template_file.bootstrap.rendered

  provisioner "file" {
    source      = "app/app.py"
    destination = "/home/${var.ssh_user}/${var.demo_dir}/app.py"

    connection {
      type        = "ssh"
      host        = google_compute_instance.demo-instance.network_interface.0.access_config.0.nat_ip
      user        = var.ssh_user
      private_key = file("${var.ssh_user}.pem")
    }
  }
}

resource "google_compute_firewall" "demo-instance" {
  name    = "ssh-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

output "connection" {
  value = "ssh -i ${var.ssh_user}.pem ${var.ssh_user}@${google_compute_instance.demo-instance.network_interface.0.access_config.0.nat_ip}"
}