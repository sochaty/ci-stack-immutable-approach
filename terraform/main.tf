module "network" {
  source              = "./modules/network"
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  zones               = var.zones
}

module "compute" {
  source = "./modules/compute"

  environment            = var.environment
  vpc_id                 = module.network.vpc_id
  key_pair_name          = var.key_pair_name
  private_subnet_ids     = module.network.private_subnet_ids
  public_subnet_ids      = module.network.public_subnet_ids
  jenkins_machine_data   = var.jenkins_machine_data
  nexus_machine_data     = var.nexus_machine_data
  postgres_machine_data  = var.postgres_machine_data
  sonarqube_machine_data = var.sonarqube_machine_data
  image_owner            = var.image_owner
  jumpbox_image_id       = var.jumpbox_image_id
  jumpbox_name           = var.jumpbox_name
  jumpbox_type           = var.jumpbox_type
  postgres_user_script   = "./scripts/postgres-user-data.sh"
  sonar_user_script      = "./scripts/sonarqube-user-data.sh"

  depends_on = [
    module.network
  ]
}