terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-unique-name" 
    key            = "path/to/myproject.tfstate"             
    region         = "us-east-2"        
    dynamodb_table = "terraform-state-lock"                
    encrypt        = true                                    
  }
}
