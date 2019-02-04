project = "devops-challenge"

region = "us-east-2"

availability_zone = ["us-east-2a", "us-east-2b", "us-east-2c"]

vpc_cidr = "10.10.0.0/16"

subnet-pri-cidr-block = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]

subnet-pub-cidr-block = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

subnet-pri-tag-name = ["subnet-pri-a", "subnet-pri-b", "subnet-pri-c"]

subnet-pub-tag-name = ["subnet-pub-a", "subnet-pub-b", "subnet-pub-c"]
