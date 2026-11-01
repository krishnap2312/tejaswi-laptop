terraform {
  backend "s3" {
    # Replace with a pre-created, private, versioned state bucket.
    bucket       = "welcometodevsecopspractisesession"
    key          = "placeholder/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
