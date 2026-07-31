project_name = "sharath-tfstate"

environment = "test"

aws_region = "ap-southeast-1"

vpc_cidr = "10.10.0.0/16"

public_subnets = {

  public-1 = {

    cidr = "10.10.1.0/24"

    az = "ap-southeast-1a"

  }

}

private_subnets = {

  private-1 = {

    cidr = "10.10.11.0/24"

    az = "ap-southeast-1a"

  }

}
