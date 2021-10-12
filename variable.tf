variable "image1" {
    default = "ubuntu-os-cloud/ubuntu-1604-lts" 
}
variable "image2" { default = "rhel-cloud/rhel-7"}
variable "machine_type" {
    default = "n1-standard-1"
}

variable "machine_count" {default = "1"}

variable "name1" {default = "name1"}
variable "name2" {default = "name2"}

variable "name3" {default = "name3"}

variable "name_count" { default = ["Server1", "Server2", "Server3"]}
  
variable "network" { default = "google_compute_network.default.name"}



variable "zone" { default = "europe-west2-a"}

variable "environment" {default = "production"}

variable "machine_type_dev" {default = "n1-standard-4"}