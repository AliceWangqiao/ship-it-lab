terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
  }
}

provider "google" {
  project = var.project
  region  = "us-central1"
}

# -------------------------
# Artifact Registry
# -------------------------
resource "google_artifact_registry_repository" "labs" {
  location      = "us-central1"
  repository_id = "labs"
  format        = "DOCKER"
}

# -------------------------
# Cloud Run (placeholder service)
# -------------------------
resource "google_cloud_run_v2_service" "app" {
  name     = "ship-it"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image
    ]
  }
}

# -------------------------
# Cloud Build Trigger (LEGACY GitHub - THIS FIXES YOUR 400 ERROR)
# -------------------------
resource "google_cloudbuild_trigger" "main" {
  name     = "ship-it-on-push"
  location = "us-central1"

  github {
    owner = var.gh_owner
    name  = "ship-it-lab"

    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"
}
