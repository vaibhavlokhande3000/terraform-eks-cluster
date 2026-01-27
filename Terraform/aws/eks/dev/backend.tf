terraform {
  backend "s3" {
    bucket         = "tfstate-ironmanav2" 
    key            = "path/to/myproject.tfstate"             
    region         = "us-east-2"        
    dynamodb_table = "terraform-state-lock"                
    encrypt        = true                                    
  }
}
