 # variable "path" {default = "/E/terraform-GCP/Credentials"}


provider "google" {
    project = "intense-howl-328405"
    region = "europe-west2-a"
#    credentials = "${file("${var.path}/secrets.json")}"
}
