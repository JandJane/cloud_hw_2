variable "token" {}

variable "folder_id" {}

variable "cloud_id" {}

variable "zone" {default = "ru-central1-a"}

terraform {
  required_providers {
    yandex = {
      version = ">= 0.49.0"
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone = var.zone
}

data "yandex_compute_image" "base_image" {
  family = "ubuntu-1804-lts"
}

resource "yandex_vpc_network" "default" {
  description = "Auto-created default network"
  name = "default"
}

resource "yandex_vpc_subnet" "tf-subnet" {
  name           = "tf-subnet"
  description    = "Subnet from Terraform"
  zone           = var.zone
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_compute_instance" "backend1" {
  name        = "backend1"
  hostname    = "backend1"
  zone        = var.zone
  platform_id = "standard-v2"

  depends_on = [yandex_vpc_subnet.tf-subnet]

  resources {
    cores  = 2
    core_fraction = 5
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base_image.id
      type     = "network-hdd"
      size     = "13"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.tf-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "admin:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "backend2" {
  name        = "backend2"
  hostname    = "backend2"
  zone        = var.zone
  platform_id = "standard-v2"

  depends_on = [yandex_vpc_subnet.tf-subnet]

  resources {
    cores  = 2
    core_fraction = 5
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base_image.id
      type     = "network-hdd"
      size     = "13"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.tf-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "admin:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "db" {
  name        = "db"
  hostname    = "db"
  zone        = var.zone
  platform_id = "standard-v2"

  depends_on = [yandex_vpc_subnet.tf-subnet]

  resources {
    cores  = 2
    core_fraction = 5
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base_image.id
      type     = "network-hdd"
      size     = "13"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.tf-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "admin:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "nginx" {
  name        = "nginx"
  hostname    = "nginx"
  zone        = var.zone
  platform_id = "standard-v2"

  depends_on = [yandex_vpc_subnet.tf-subnet]

  resources {
    cores  = 2
    core_fraction = 5
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.base_image.id
      type     = "network-hdd"
      size     = "13"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.tf-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "admin:${file("~/.ssh/id_rsa.pub")}"
  }
}