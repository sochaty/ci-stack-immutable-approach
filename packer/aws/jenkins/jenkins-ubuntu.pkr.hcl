locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "jenkins-server-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20221206"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    # most_recent = true
    owners = ["099720109477"]
  }

  ssh_username = "ubuntu"
  tags         = var.tags
  aws_polling {
    delay_seconds = 30
    max_attempts  = 300
  }

}

build {
  name        = "jenkins-server"
  description = <<EOF
  This build creates ubuntu images for ubuntu versions :
  * 20.04
  For the following builders :
  * amazon-ebs
  EOF
  sources     = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "./scripts/jenkins.sh"
  }
}