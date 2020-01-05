
provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "root"
}


provider "aws" {
  alias                   = "dub"
  region                  = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "root"
}

provider "aws" {
  alias                   = "irl"
  region                  = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "root"
}


provider "aws" {
  alias                   = "fra"
  region                  = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "root"
}

provider "aws" {
  alias                   = "sig"
  region                  = "ap-southeast-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "root"
}

