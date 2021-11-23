// Global
variable "profile_name" { default = "sre5_taehun" }

variable "cred_file" { default = "/home/user/.aws/credentials" }

variable "region" { default = "ap-northeast-2" }

#################################################################
# VPC Configuration
#################################################################

// CIDR
variable "cidr_block" {
  description = "Amazon Virtual Private Cloud CIDR range."
}

variable "public_subnet_cidr" {
  default     = []
  description = "AWS Public Subnet CIDR Block"
}

variable "private_subnet_cidr" {
  default     = []
  description = "AWS Private Subnet CIDR Block"
}

variable "db_subnet_cidr" {
  default     = []
  description = "AWS DB Subnet CIDR Block"
}


variable "available_azs" {
  description = "AWS Available AZs you would like to deploy."
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

// VPC Options
variable "enable_dns_hostnames" {
  default     = true
  description = "Enable DNS Hostname"
  type        = bool
}

variable "enable_dns_support" {
  default     = true
  description = "Enable DNS Support"
  type        = bool
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway of Not"
  default     = true
  type        = bool
}

#################################################################
# EC2
#################################################################
variable "default_instance_type" {
  default     = ""
  description = "Default EC2 Instance Type"
}

variable "key_pair" {
  default = ""
}

variable "jenkins" {
  default = {}
}


#################################################################
# Security Groups
#################################################################

// 1. Bastion SG Inbound
variable "bastion_ingress_rules" {
  description = "Bastion ingresses. From, To, Protocol, Cidrs, Desc"
  type        = list(any)
  default     = []
}

// 2. Jenkins SG Inbound
variable "jenkins_ingress_rules" {
  type = map(object(
    {
      from  = number
      to    = number
      proto = string
      cidr  = list(string)
      desc  = string
    }
  ))

  default = {}
}



// EKS
variable "eks_enabled_log_types" {
  type    = list(string)
  default = []
}

variable "eks_version" {}

// Worker Node
variable "worker_size" {
  description = "Worker Node Size"
  type        = map(string)
  default = {
    "desired" = "1"
    "min"     = "1"
    "max"     = "2"
  }
}

variable "worker_instance_types" {
  description = "Maximum number of worker nodes in private subnet."
  type        = list(string)
}

variable "worker_disk_size" {
  description = "Minimum number of worker nodes in private subnet."
  type        = number
}

// Tagging
variable "tags" {}

variable "owner_tag" {
  type        = string
  description = "Owner tag for resource pricing management, e.g taehun.kim"
  default     = "taehun.kim"
}


// EFS File System
variable "efs" {
  default = {}
}