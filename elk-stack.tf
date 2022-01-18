provider "google" {
    credentials = file("ecstatic-acumen-338215-4953c1d1c74c.json")
    project = "ecstatic-acumen-338215"
    region = "europe-central2"
    zone = "europe-central2-a"
}

resource "google_compute_address" "static-01" {
  name = "elk-01"
}

resource "google_compute_address" "static-02" {
  name = "elk-02"
}

resource "google_compute_address" "static-03" {
  name = "elk-03"
}

resource "google_compute_address" "static-04" {
  name = "elk-04"
}

resource "google_compute_address" "static-05" {
  name = "elk-05"
}


resource "google_compute_instance" "elk-01" {
    name         = "elk-01"
    tags = ["web","http-server"]
    machine_type = "custom-2-8192"
	  allow_stopping_for_update = "true"

    metadata = {
     ssh-keys = "root:${file("~/.ssh/google_key_instance.pub")}"
    }

    boot_disk {
        initialize_params{
            image = "ubuntu-2004-focal-v20200720"
            size= 50
        }
    }
    
    network_interface{
        network = "default"
        access_config {nat_ip = "${google_compute_address.static-01.address}"}
    }     
}

resource "google_compute_instance" "elk-02" {
    name         = "elk-02"
    tags = ["web","http-server"]
    machine_type = "custom-1-6656"
    zone            = "europe-central2-b"
    allow_stopping_for_update = "true"

    metadata = {
     ssh-keys = "root:${file("~/.ssh/google_key_instance.pub")}"
    }

    boot_disk {
        initialize_params{
            image = "ubuntu-2004-focal-v20200720"
            size= 50
        }
    }
    
    network_interface{
        network = "default"
        access_config {nat_ip = "${google_compute_address.static-02.address}"}
    }     
}


resource "google_compute_instance" "elk-03" {
    name         = "elk-03"
    tags = ["web","http-server"]
    machine_type = "custom-1-6656"
	  allow_stopping_for_update = "true"

    metadata = {
     ssh-keys = "root:${file("~/.ssh/google_key_instance.pub")}"
    }

    boot_disk {
        initialize_params{
            image = "ubuntu-2004-focal-v20200720"
            size= 50
        }
    }
    
    network_interface{
        network = "default"
        access_config {nat_ip = "${google_compute_address.static-03.address}"}
    }     
}


resource "google_compute_instance" "elk-04" {
    name         = "elk-04"
    tags = ["web","http-server"]
    machine_type = "custom-2-8192"
	  allow_stopping_for_update = "true"

    metadata = {
     ssh-keys = "root:${file("~/.ssh/google_key_instance.pub")}"
    }

    boot_disk {
        initialize_params{
            image = "ubuntu-2004-focal-v20200720"
            size= 50
        }
    }
    
    network_interface{
        network = "default"
        access_config {nat_ip = "${google_compute_address.static-04.address}"}
    }     
}

resource "google_compute_instance" "elk-05" {
    name         = "elk-05"
    tags = ["web","http-server"]
    machine_type = "custom-2-8192"
	 allow_stopping_for_update = "true"

    metadata = {
     ssh-keys = "root:${file("~/.ssh/google_key_instance.pub")}"
    }

    boot_disk {
        initialize_params{
            image = "ubuntu-2004-focal-v20200720"
            size= 50
        }
    }
    
    network_interface{
        network = "default"
        access_config {nat_ip = "${google_compute_address.static-05.address}"}
    }     
}

resource "google_compute_firewall" "default" {
 name    = "web-firewall"
 network = "default"

 allow {
   protocol = "icmp"
 }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "1000-4000"]
  }

 source_ranges = ["0.0.0.0/0"]
 target_tags = ["web"]
}

