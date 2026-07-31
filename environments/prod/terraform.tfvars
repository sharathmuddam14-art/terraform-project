project_name = "sharath-tfstate"

environment = "prod"

aws_region = "ap-southeast-1"

vpc_cidr = "10.20.0.0/16"

public_subnets = {

  public-1 = {

    cidr = "10.20.1.0/24"

    az = "ap-southeast-1a"

  }

  public-2 = {

    cidr = "10.20.2.0/24"

    az = "ap-southeast-1b"

  }

}

private_subnets = {

  private-1 = {

    cidr = "10.20.11.0/24"

    az = "ap-southeast-1a"

  }

  private-2 = {

    cidr = "10.20.12.0/24"

    az = "ap-southeast-1b"

  }

}
