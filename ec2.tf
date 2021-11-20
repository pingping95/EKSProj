// Bastion EC2
module "bastion" {
  source         = "../../modules/ec2"
  name           = "${local.name_prefix}-bastion"
  instance_count = 0

  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.default_instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_ids             = module.main_vpc.public_subnets_ids // Network Configuration
  user_data              = base64encode(file("./scripts/common/amz2_init.sh"))

  tags = {
    Environment = var.tags.Environment
    Owner       = var.owner_tag
  }
}