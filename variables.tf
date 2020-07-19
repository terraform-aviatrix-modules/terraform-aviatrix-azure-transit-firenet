variable "controller_ip" {}

variable "username" {}

variable "password" {}

variable "region" {
  description = "The Azure region to deploy this module in"
  type        = string
}

variable "cidr" {
  description = "The CIDR range to be used for the VPC"
  type        = string
}

variable "azure_account_name" {
  description = "The Azure account name, as known by the Aviatrix controller"
  type        = string
}

variable "instance_size" {
  description = "Azure Instance size for the Aviatrix gateways"
  type        = string
  default     = "Standard_B2ms"
}

variable "fw_instance_size" {
  description = "Azure Instance size for the NGFW's"
  type        = string
  default     = "Standard_D3_v2"
}

variable "ha_gw" {
  description = "Boolean to determine if module will be deployed in HA or single mode"
  type        = bool
  default     = true
}

variable "is_checkpoint" {
  description = "Boolean to determine if module deploys Check Point"
  type        = bool
  default     = false
}

variable "checkpoint_password" {
  description = "Check Point firewall instance password"
  type        = string
  default     = ""
}

variable "attached" {
  description = "Boolean to determine if the spawned firewall instances will be attached on creation"
  type        = bool
  default     = true
}

variable "firewall_image" {
  description = "The firewall image to be used to deploy the NGFW's"
  type        = string
}

variable "firewall_image_version" {
  description = "The firewall image version specific to the NGFW vendor image"
  type        = string
}

