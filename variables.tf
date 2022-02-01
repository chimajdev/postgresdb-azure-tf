variable "subnet_id" {
  description = "The resource ID of the subnet"
  default     = "/subscriptions/d01be024-8927-405d-8eac-512e1d310cb3/resourceGroups/app-rg/providers/Microsoft.Network/virtualNetworks/acctvnet/subnets/subnet1"
}  # Change subnet id

variable "admin_username" {
  description = "Admin Username for DB"
  default     = "admin"
  sensitive   = true
}

variable "admin_password" {
  description = "Admin Password for DB"
  sensitive   = true
}