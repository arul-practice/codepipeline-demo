provider "aws" {
  region  = var.aws_region
}

locals {
  env = "${terraform.workspace == "default" ? "PRD" : upper(element(split("-",terraform.workspace),0)) }"
  namespace = "${lower(local.env)}"
  location = "${element(split("-",terraform.workspace),1) == local.namespace ? "" : format("-%s",element(split("-",terraform.workspace),1)) }"
  common_tags = {
    "Service"           = "iotaccount"
    "Environment"       = "PROD"
    "IOTEnvironment"    = local.env
    "PONumber"          = "PO1502207953"
    "LMEntity"          = "VGSL"
    "BU"                = "GROUP-ENTERPRISE"
    "Project"           = "iotaccount"
    "ManagedBy"         = "iotinfrastructure@vodafone.com"
    "SecurityZone"      = "A"
    "Confidentiality"   = "C3"
    "TaggingVersion"    = "V2.0"
    "BusinessService"   = "VGSL-AWS-IOTACCOUNTS-PROD"
    "terraform"         = "Yes"
    "terraform-project" = "iotaccount"
  }
} 


module "prereqs" {
  source        = "./modules/prereqs"
  aws_region    = var.aws_region
  name_prefix   = var.name_prefix
  name_suffix   = var.name_suffix
  environment   = local.env
  aws_account   = var.aws_account
  subscriptions = var.subscriptions
}

module "iam" {
  source        = "./modules/iam"
  aws_region    = var.aws_region
  name_prefix   = var.name_prefix
  name_suffix   = var.name_suffix
  environment   = var.environment
  aws_account   = var.aws_account
  subscriptions = var.subscriptions
}

module "approval" {
  source   = "./modules/approval"
  approval = "False"
}

module "WithApprovalStage" {
  source          = "./modules/codepipeline/Approval"
  approval        = module.approval.approval
  aws_region      = var.aws_region
  name_prefix     = var.name_prefix
  name_suffix     = var.name_suffix
  environment     = var.environment
  aws_account     = var.aws_account
  role_arn        = module.iam.role_arn
  subscriptions   = var.subscriptions
  tflambda_bucket = module.prereqs.tflambda_bucket
  common_tags   = local.common_tags
}

module "NoApprovalStage" {
  source          = "./modules/codepipeline/NoApproval"
  approval        = module.approval.approval
  aws_region      = var.aws_region
  name_prefix     = var.name_prefix
  name_suffix     = var.name_suffix
  environment     = var.environment
  aws_account     = var.aws_account
  role_arn        = module.iam.role_arn
  tflambda_bucket = module.prereqs.tflambda_bucket
  common_tags     = local.common_tags
}
