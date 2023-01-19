variable "region" {
  type        = string
  description = "AWS Region"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance type"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}

# test the workflow