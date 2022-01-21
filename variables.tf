variable "region" {
  description = "The Azure region to deploy this module in"
  type        = string
}

variable "cidr" {
  description = "The CIDR range to be used for the VNET"
  type        = string
}

variable "account" {
  description = "The Azure account name, as known by the Aviatrix controller"
  type        = string
}

variable "instance_size" {
  description = "Azure Instance size for the Aviatrix gateways"
  type        = string
  default     = "Standard_B2ms"
}

variable "insane_instance_size" {
  description = "Azure Instance size for the Aviatrix gateways"
  type        = string
  default     = "Standard_D3_v2"
}

variable "fw_instance_size" {
  description = "Azure Instance size for the NGFW's"
  type        = string
  default     = "Standard_D3_v2"
}

variable "password" {
  description = "Firewall instance password"
  type        = string
  default     = "Aviatrix#1234"
}

variable "attached" {
  description = "Boolean to determine if the spawned firewall instances will be attached on creation"
  type        = bool
  default     = true
}

variable "fw_amount" {
  description = "Integer that determines the amount of NGFW instances to launch"
  type        = number
  default     = 2
}

variable "name" {
  description = "Custom name for VNETs, gateways, and firewalls"
  type        = string
  default     = ""
}

variable "prefix" {
  description = "Boolean to determine if name will be prepended with avx-"
  type        = bool
  default     = true
}

variable "suffix" {
  description = "Boolean to determine if name will be appended with -spoke"
  type        = bool
  default     = true
}

variable "firewall_image" {
  description = "The firewall image to be used to deploy the NGFW's"
  type        = string
  default     = ""
}

variable "firewall_image_version" {
  description = "The firewall image version specific to the NGFW vendor image"
  type        = string
  default     = ""
}

variable "firewall_username" {
  description = "The username for the administrator account"
  type        = string
  default     = "fwadmin"
}

variable "ha_gw" {
  description = "Set to false to deploy single Aviatrix gateway. When set to false, fw_amount is ignored and only a single NGFW instance is deployed."
  type        = bool
  default     = true
}

variable "egress_enabled" {
  description = "Set to true to enable egress inspection on the firewall instances"
  type        = bool
  default     = false
}

variable "inspection_enabled" {
  description = "Set to false to disable inspection on the firewall instances"
  type        = bool
  default     = true
}

variable "insane_mode" {
  description = "Set to true to enable Aviatrix high performance encryption."
  type        = bool
  default     = false
}

variable "connected_transit" {
  description = "Set to false to disable connected transit."
  type        = bool
  default     = true
}

variable "bgp_manual_spoke_advertise_cidrs" {
  description = "Define a list of CIDRs that should be advertised via BGP."
  type        = string
  default     = ""
}

variable "learned_cidr_approval" {
  description = "Set to true to enable learned CIDR approval."
  type        = string
  default     = "false"
}

variable "active_mesh" {
  description = "Set to false to disable active mesh."
  type        = bool
  default     = true
}

variable "enable_segmentation" {
  description = "Switch to true to enable transit segmentation"
  type        = bool
  default     = false
}

variable "single_az_ha" {
  description = "Set to true if Controller managed Gateway HA is desired"
  type        = bool
  default     = true
}

variable "single_ip_snat" {
  description = "Enable single_ip mode Source NAT for this container"
  type        = bool
  default     = false
}

variable "enable_advertise_transit_cidr" {
  description = "Switch to enable/disable advertise transit VPC network CIDR for a VGW connection"
  type        = bool
  default     = false
}

variable "bgp_polling_time" {
  description = "BGP route polling time. Unit is in seconds"
  type        = string
  default     = "50"
}

variable "bgp_ecmp" {
  description = "Enable Equal Cost Multi Path (ECMP) routing for the next hop"
  type        = bool
  default     = false
}

variable "bootstrap_storage_name_1" {
  description = "The firewall bootstrap_storage_name"
  type        = string
  default     = null
}

variable "storage_access_key_1" {
  description = "The storage_access_key to access the storage account"
  type        = string
  default     = null
}

variable "file_share_folder_1" {
  description = "The file_share_folder containing the bootstrap files"
  type        = string
  default     = null
}

variable "bootstrap_storage_name_2" {
  description = "The firewall bootstrap_storage_name"
  type        = string
  default     = ""
}

variable "storage_access_key_2" {
  description = "The storage_access_key to access the storage account"
  type        = string
  default     = ""
}

variable "file_share_folder_2" {
  description = "The file_share_folder containing the bootstrap files"
  type        = string
  default     = ""
}

variable "local_as_number" {
  description = "The gateways local AS number"
  type        = number
  default     = null
}

variable "enable_bgp_over_lan" {
  description = "Enable BGp over LAN. Creates eth4 for integration with SDWAN for example"
  type        = bool
  default     = false
}

variable "enable_egress_transit_firenet" {
  description = "Set to true to enable egress on transit gw"
  type        = bool
  default     = false
}

variable "az_support" {
  description = "Set to true if the Azure region supports AZ's"
  type        = bool
  default     = true
}

variable "az1" {
  description = "AZ Zone to be used for GW deployment."
  type        = string
  default     = "az-1"
}

variable "az2" {
  description = "AZ Zone to be used for HAGW deployment."
  type        = string
  default     = "az-2"
}

variable "resource_group" {
  description = "Provide the name of an existing resource group."
  type        = string
  default     = null
}

variable "tunnel_detection_time" {
  description = "The IPsec tunnel down detection time for the Spoke Gateway in seconds. Must be a number in the range [20-600]."
  type        = number
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the gateway."
  type        = map(string)
  default     = null
}

variable "enable_multi_tier_transit" {
  description = "Set to true to enable multi tier transit."
  type        = bool
  default     = false
}

variable "egress_static_cidrs" {
  description = "List of egress static CIDRs."
  type        = list(string)
  default     = []
}

variable "firewall_image_id" {
  description = "Firewall image ID."
  type        = string
  default     = null
}

variable "learned_cidrs_approval_mode" {
  description = "Learned cidrs approval mode. Defaults to Gateway. Valid values: gateway, connection"
  type        = string
  default     = null
}

variable "fail_close_enabled" {
  description = "Set to true to enable fail_close"
  type        = bool
  default     = null
}

variable "user_data_1" {
  description = "User data for bootstrapping Fortigate and Checkpoint firewalls"
  type        = string
  default     = null
}

variable "user_data_2" {
  description = "User data for bootstrapping Fortigate and Checkpoint firewalls"
  type        = string
  default     = ""
}

variable "east_west_inspection_excluded_cidrs" {
  description = "Network List Excluded From East-West Inspection."
  type        = list(string)
  default     = null
}

variable "gov" {
  description = "Set to true if deploying this module in Azure GOV."
  type        = bool
  default     = false
}

variable "deploy_firenet" {
  description = "Set to false to fully deploy the Transit Firenet, but without the actual NGFW instances."
  type        = bool
  default     = true
}

locals {
  is_checkpoint            = length(regexall("check", lower(var.firewall_image))) > 0    #Check if fw image contains checkpoint. Needs special handling for the username/password
  is_palo                  = length(regexall("palo", lower(var.firewall_image))) > 0     #Check if fw image contains palo. Needs special handling for management_subnet (CP & Fortigate null)
  is_aviatrix              = length(regexall("aviatrix", lower(var.firewall_image))) > 0 #Check if fw image is Aviatrix FQDN Egress
  lower_name               = length(var.name) > 0 ? replace(lower(var.name), " ", "-") : replace(lower(var.region), " ", "-")
  prefix                   = var.prefix ? "avx-" : ""
  suffix                   = var.suffix ? "-firenet" : ""
  name                     = "${local.prefix}${local.lower_name}${local.suffix}"
  cidrbits                 = tonumber(split("/", var.cidr)[1])
  newbits                  = 26 - local.cidrbits
  netnum                   = pow(2, local.newbits)
  subnet                   = var.insane_mode ? cidrsubnet(var.cidr, local.newbits, local.netnum - 2) : aviatrix_vpc.default.public_subnets[2].cidr
  ha_subnet                = var.insane_mode ? cidrsubnet(var.cidr, local.newbits, local.netnum - 1) : aviatrix_vpc.default.public_subnets[3].cidr
  bootstrap_storage_name_2 = length(var.bootstrap_storage_name_2) > 0 ? var.bootstrap_storage_name_2 : var.bootstrap_storage_name_1 #If storage 2 name is not provided, fallback to storage name 1.
  storage_access_key_2     = length(var.storage_access_key_2) > 0 ? var.storage_access_key_2 : var.storage_access_key_1             #If storage 1 key is not provided, fallback to storage key 1.
  file_share_folder_2      = length(var.file_share_folder_2) > 0 ? var.file_share_folder_2 : var.file_share_folder_1                #If storage 2 folder is not provided, fallback to folder 1.
  user_data_2              = length(var.user_data_2) > 0 ? var.user_data_2 : var.user_data_1                                        #If user data 2 name is not provided, fallback to user data 1.
  cloud_type               = var.gov ? 32 : 8
}
