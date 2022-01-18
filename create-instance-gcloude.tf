provider "google" {
    credentials = file("terraform_key_gcloude.json")
    project = "singular-tuner-328410"
    region = "europe-central2"
    zone = "europe-central2-a"
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_compute_instance" "instance-3" {
    name         = "instance-3"
    tags = ["web","http-server"]
    machine_type = "custom-1-2048"

    metadata = {
     ssh-keys = "lears:${file("~/.ssh/remote.pub")} \nroot:${file("~/.ssh/remote2.pub")}"
     //ssh-keys = "root:${file("~/.ssh/remote2.pub")}"
    }

    boot_disk {
        initialize_params{
            image = "debian-10-buster-v20211028"
            size= 20
        }
    }
    
    network_interface{
        network = "default"
        access_config {nat_ip = "${google_compute_address.static.address}"}
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

/*zabbix server*/

resource "google_compute_address" "static-zabbix" {
  name = "ipv4-address-zabbix"
}

resource "google_compute_instance" "instance-4" {
    name         = "instance-4"
    tags = ["web","http-server"]
    machine_type = "custom-1-2048"

    metadata = {
      ssh-keys = "lears:${file("~/.ssh/remote.pub")} \nroot:${file("~/.ssh/remote2.pub")}"
    }

    boot_disk {
        initialize_params{
            image = "centos-8-v20211105"
            size= 20
        }
    }
    
    network_interface{
        network = "default"
        access_config {nat_ip = "${google_compute_address.static-zabbix.address}"}
    }     
}