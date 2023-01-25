module "network" {
  source              = "./modules/network"
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  zones               = var.zones
}

module "compute" {
  source             = "./modules/compute"
  instance_type      = var.instance_type
  max_instance_size  = var.max_instance_size
  min_instance_size  = var.min_instance_size
  key_pair_name      = var.key_pair_name
  environment        = var.environment
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  vpc_id             = module.network.vpc_id
  image_id           = var.image_id
  # for test Windows Server EC2 instance
  win_ec2_image_id = var.win_ec2_image_id
  win_ec2_instance_type = var.instance_type
  # win_ec2_private_ip = var.win_ec2_private_ip
  win_ec2_subnet_id =  tolist(module.network.public_subnet_ids)[0]
  depends_on = [
    module.network
  ]
}