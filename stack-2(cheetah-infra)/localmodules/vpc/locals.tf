locals {
  az_names = data.aws_availability_zones.azs.names

  public_subnet_count  = 2
  private_subnet_count = 2
}