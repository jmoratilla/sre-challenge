terraform {
    backend "s3" {
        bucket = "moratilla-sre-challenge"
        key = "terraform.tfstate"
        region = "eu-west-1"
    }
}
