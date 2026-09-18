terraform {

  backend "s3" {

    bucket = "sharath-tfstate-397332849331"

    key = "test/terraform.tfstate"

    region = "ap-southeast-1"

    dynamodb_table = "sharath-tfstate-locks"

    encrypt = true

  }

}
