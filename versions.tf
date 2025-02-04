terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }
  required_version = ">=1.0.0"
}
