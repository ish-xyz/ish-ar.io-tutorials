provider "google" {
  project     = "ish-ar-io"
  credentials = file("keyfile.json")
  region      = "europe-west2"
  version     = "~> 3.10.0"
}

