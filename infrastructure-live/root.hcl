# Ealrier, the file name is terragrunt.hcl, 
# but now terraform is suggesting it to use root.hcl, 
# because it is the root configuration file for our infrastructure.

# If i execute this block in DEV environment, 
# it will create provider.tf file with the content of provider block.

# If i execute this block in PROD environment,
# it will create provider.tf file with the content of provider block.

generate "provider" {
  path      = "provider.tf"
  #if_exists = "overwrite_terragrunt"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"
  #version = "~> 4.0"
  #allowed_account_ids = ["123456789012"]
}
EOF
}
remote_state {
  backend = "s3"
  config = {
    bucket         = "roboshop-infra-eks-sudheer"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    # encrypt        = true
    # dynamodb_table = "my-lock-table"
  }
   
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
    #contents  = <<EOF
    }
}