terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.11.0"
    }
  }
}

provider "google" {
  #credentials = "./keys/my-creds.json" # This method is NOT RECOMMENDED  must be set using env var
  project     = "data-engineering-417912"              # Replace with your Google Cloud project ID on GPC Dashboard
  region      = "europe-west1"         # Set your desired region
}

resource "google_storage_bucket" "taxi-bucket" {
  name          = "aerobic-badge-408610-taxi-bucket"
  location      = "EU"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "taxi-dataset" {
  dataset_id = "taxi_dataset"
  location   = "EU"
}