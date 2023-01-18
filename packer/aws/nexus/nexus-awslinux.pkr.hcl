locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "aws_linux" {
  ami_name      = "nexus-server-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm-2.0.20221210.1-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners = ["137112412989"]
  }

  ssh_username = "ec2-user"
  tags         = var.tags
  aws_polling {
    delay_seconds = 30
    max_attempts  = 300
  }

}

build {
  name        = "nexus-server"
  description = <<EOF
  This build creates aws linux images for nexus server
  EOF
  sources     = ["source.amazon-ebs.aws_linux"]

  provisioner "shell" {
    script = "../../../scripts/nexus.sh"
  }
}