region = "us-east-1"
# VPC variables for specific environment
vpc_cidr    = "10.0.0.0/16"
environment = "Development"
# "10.0.5.0/24"
public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
# "10.0.6.0/24"
private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
# "c"
zones = ["a", "b"]

key_pair_name = "demokey1"

jenkins_machine_data = {
  image = "jenkins-server"
  name  = "JenkinsServer"
  type  = "t2.medium"
}

nexus_machine_data = {
  image = "nexus-server"
  name  = "NexusServer"
  type  = "t2.medium"
}

postgres_machine_data = {
  image = "postgres-sonardb-server"
  name  = "PostgresServer"
  type  = "t2.medium"
}

sonarqube_machine_data = {
  image = "sonarqube-server"
  name  = "SonarqubeServer"
  type  = "t2.medium"
}

image_owner = "200244692886"

jumpbox_image_id = "ami-00874d747dde814fa"

jumpbox_name = "BastionServer"

jumpbox_type = "t2.small"