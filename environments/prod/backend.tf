terraform {

  backend "s3" {

    bucket = "sharath-tfstate-010160406667"

    key = "prod/terraform.tfstate"

    region = "ap-southeast-1"

    dynamodb_table = "sharath-tfstate-locks"

    encrypt = true

  }

}
