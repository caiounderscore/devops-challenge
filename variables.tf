variable "vpc_cidr" {}

variable "availability_zone" {
  type = "list"
}

variable "project" {}

variable "subnet-pub-tag-name" {
  type = "list"
}

variable "subnet-pub-cidr-block" {
  type = "list"
}

variable "subnet-pri-tag-name" {
  type = "list"
}

variable "subnet-pri-cidr-block" {
  type = "list"
}

variable "region" {}
