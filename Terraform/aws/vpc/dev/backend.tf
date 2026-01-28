terraform {
  backend "s3" {
    bucket         = "tfstate-ironmanav-ve3" 
    key            = "vpc/terraform.tfstate"             
    region         = "us-east-2"        
    dynamodb_table = "terraform-state-lock"                
    encrypt        = true                                    
  }
}
