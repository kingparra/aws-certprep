packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "amzl" {
  filters = {
    name = "amzn2-ami-hvm-2.*-x86_64-gp2"
    root-device-type = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners = ["amazon"]
  region = "us-east-1"
}

# https://developer.hashicorp.com/packer/plugins/builders/amazon/ebs
source "amazon-ebs" "amzl" {
  source_ami = data.amazon-ami.amzl.id
  ami_name = "AmazonLinux2WithCwAgent"
  tags = {
    "Class" = "Aurora"
    "Module" = "1"
    "Lab" = "1"
  }
  instance_type = "t2.micro"
  ssh_username = "ec2-user"
  ssh_timeout = "5m"
  associate_public_ip_address = true
  force_delete_snapshot = true
  force_deregister = true
  temporary_iam_instance_profile_policy_document {
    Statement {
        Action   = ["s3:*", "s3-object-lambda:*"]
        Effect   = "Allow"
        Resource = ["*"]
    }
    Version = "2012-10-17"
  }
}

build {
  name = "AmazonLinux2WithCwAgent"
  sources = ["source.amazon-ebs.amzl"]

  provisioner "ansible" {
    user = "ec2-user"
    playbook_file = "./playbook.yml"
    use_proxy = false

    ## Workaround for bug:
    ## https://github.com/hashicorp/packer-plugin-ansible/issues/140
    extra_arguments = [
      "--ssh-extra-args",
      ## Yes, this arg is intended to be one long string.
      ## anything after the --ssh-extra-args argument
      ## gets passed verbatim to ssh, which does it's
      ## own arg parsing. There are two level of arg
      ## parsing.
      "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"
    ]
  }
}
