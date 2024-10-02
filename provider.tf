terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  access_key = var.akey
  secret_key = var.skey
  region     = "us-east-2"
}

# terraform { 
#  cloud { 

#    organization = "NW-Ewan" 

#    workspaces { 
#      name = "NW-Ewan-Prod" 
#    } 
#  } 
# }

terraform {
  cloud {
    organization = "NW-Ewan"
    hostname     = "app.terraform.io"
    workspaces {
      tags = ["ewan-tag"]
    }
  }
}