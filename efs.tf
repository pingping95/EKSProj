# // EFS Filesystem (For EFS CSI Driver)
# resource "aws_efs_file_system" "eks" {

#   performance_mode = var.efs.performance_mode
#   throughput_mode = var.efs.throughput_mode
#   encrypted = var.efs.encrypted

#   dynamic "lifecycle_policy" {
#     for_each = length(var.efs.transition_to_ia) > 0 || length(var.efs.transition_to_primary_storage_class) > 0 ? [1] : []

#     content {
#       transition_to_ia                    = try(var.efs.transition_to_ia[0], null)
#       transition_to_primary_storage_class = try(var.efs.transition_to_primary_storage_class[0], null)
#     }
#   }

#   tags = {
#     Name  = "${local.name_prefix}-efs"
#     Owner = var.owner_tag
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

# }

# resource "aws_efs_mount_target" "eks" {
#   count = length(module.main_vpc.private_subnets_ids)
#   file_system_id  = aws_efs_file_system.eks.id
#   subnet_id       = module.main_vpc.private_subnets_ids[count.index]
#   security_groups = [aws_security_group.efs.id]

#   lifecycle {
#     create_before_destroy = true
#   }
# }