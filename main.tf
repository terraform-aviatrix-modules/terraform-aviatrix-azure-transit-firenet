#Transit VPC
resource "aviatrix_vpc" "default" {
  cloud_type           = 8
  name                 = local.name
  region               = var.region
  cidr                 = var.cidr
  account_name         = var.account
  aviatrix_firenet_vpc = true
  aviatrix_transit_vpc = false
  resource_group       = var.resource_group
}

#Transit GW
resource "aviatrix_transit_gateway" "default" {
  enable_active_mesh               = var.active_mesh
  cloud_type                       = 8
  vpc_reg                          = var.region
  gw_name                          = local.name
  gw_size                          = var.insane_mode ? var.insane_instance_size : var.instance_size
  vpc_id                           = aviatrix_vpc.default.vpc_id
  account_name                     = var.account
  subnet                           = local.subnet
  ha_subnet                        = var.ha_gw ? local.ha_subnet : null
  insane_mode                      = var.insane_mode
  enable_transit_firenet           = true
  ha_gw_size                       = var.ha_gw ? (var.insane_mode ? var.insane_instance_size : var.instance_size) : null
  connected_transit                = var.connected_transit
  bgp_manual_spoke_advertise_cidrs = var.bgp_manual_spoke_advertise_cidrs
  enable_learned_cidrs_approval    = var.learned_cidr_approval
  enable_segmentation              = var.enable_segmentation
  single_az_ha                     = var.single_az_ha
  single_ip_snat                   = var.single_ip_snat
  enable_advertise_transit_cidr    = var.enable_advertise_transit_cidr
  bgp_polling_time                 = var.bgp_polling_time
  bgp_ecmp                         = var.bgp_ecmp
  enable_egress_transit_firenet    = var.enable_egress_transit_firenet
  local_as_number                  = var.local_as_number
  enable_bgp_over_lan              = var.enable_bgp_over_lan
  zone                             = var.az_support ? var.az1 : null
  ha_zone                          = var.ha_gw ? (var.az_support ? var.az2 : null) : null
  tunnel_detection_time            = var.tunnel_detection_time
  tags                             = var.tags
  enable_multi_tier_transit        = var.enable_multi_tier_transit
}

#Firewall instances
resource "aviatrix_firewall_instance" "firewall_instance" {
  count                  = var.ha_gw ? 0 : (local.is_aviatrix ? 0 : 1) #If ha is false, and is_aviatrix is false, deploy 1
  firewall_name          = "${local.name}-fw"
  firewall_size          = var.fw_instance_size
  vpc_id                 = aviatrix_vpc.default.vpc_id
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  egress_subnet          = aviatrix_vpc.default.subnets[0].cidr
  firenet_gw_name        = aviatrix_transit_gateway.default.gw_name
  username               = local.is_checkpoint ? "admin" : var.firewall_username
  password               = var.password
  management_subnet      = local.is_palo ? aviatrix_vpc.default.subnets[2].cidr : null
  bootstrap_storage_name = var.bootstrap_storage_name_1
  storage_access_key     = var.storage_access_key_1
  file_share_folder      = var.file_share_folder_1
  zone                   = var.az_support ? var.az1 : null
  firewall_image_id      = var.firewall_image_id
}

resource "aviatrix_firewall_instance" "firewall_instance_1" {
  count                  = var.ha_gw ? (local.is_aviatrix ? 0 : 1) : 0 #If ha is true, and is_aviatrix is false, deploy 1
  firewall_name          = "${local.name}-fw1"
  firewall_size          = var.fw_instance_size
  vpc_id                 = aviatrix_vpc.default.vpc_id
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  egress_subnet          = aviatrix_vpc.default.subnets[0].cidr
  firenet_gw_name        = aviatrix_transit_gateway.default.gw_name
  username               = local.is_checkpoint ? "admin" : var.firewall_username
  password               = var.password
  management_subnet      = local.is_palo ? aviatrix_vpc.default.subnets[2].cidr : null
  bootstrap_storage_name = var.bootstrap_storage_name_1
  storage_access_key     = var.storage_access_key_1
  file_share_folder      = var.file_share_folder_1
  zone                   = var.az_support ? var.az1 : null
  firewall_image_id      = var.firewall_image_id
}

resource "aviatrix_firewall_instance" "firewall_instance_2" {
  count                  = var.ha_gw ? (local.is_aviatrix ? 0 : 1) : 0 #If ha is true, and is_aviatrix is false, deploy 1
  firewall_name          = "${local.name}-fw2"
  firewall_size          = var.fw_instance_size
  vpc_id                 = aviatrix_vpc.default.vpc_id
  firewall_image         = var.firewall_image
  firewall_image_version = var.firewall_image_version
  egress_subnet          = aviatrix_vpc.default.subnets[1].cidr
  firenet_gw_name        = aviatrix_transit_gateway.default.ha_gw_name
  username               = local.is_checkpoint ? "admin" : var.firewall_username
  password               = var.password
  management_subnet      = local.is_palo ? aviatrix_vpc.default.subnets[3].cidr : null
  bootstrap_storage_name = local.bootstrap_storage_name_2
  storage_access_key     = local.storage_access_key_2
  file_share_folder      = local.file_share_folder_2
  zone                   = var.az_support ? var.az2 : null
  firewall_image_id      = var.firewall_image_id
}

#FQDN Egress filtering instances
resource "aviatrix_gateway" "egress_instance" {
  count         = var.ha_gw ? 0 : (local.is_aviatrix ? 1 : 0) #If ha is false, and is_aviatrix is true, deploy 1
  cloud_type    = 8
  account_name  = var.account
  gw_name       = "${local.name}-egress-gw"
  vpc_id        = aviatrix_vpc.default.vpc_id
  vpc_reg       = var.region
  gw_size       = var.fw_instance_size
  subnet        = aviatrix_vpc.default.subnets[2].cidr
  fqdn_lan_cidr = aviatrix_transit_gateway.default.lan_interface_cidr
  zone          = var.az_support ? var.az1 : null
}

resource "aviatrix_gateway" "egress_instance_1" {
  count         = var.ha_gw ? (local.is_aviatrix ? 1 : 0) : 0 #If ha is true, and is_aviatrix is true, deploy 1
  cloud_type    = 8
  account_name  = var.account
  gw_name       = "${local.name}-egress-gw1"
  vpc_id        = aviatrix_vpc.default.vpc_id
  vpc_reg       = var.region
  gw_size       = var.fw_instance_size
  subnet        = aviatrix_vpc.default.subnets[1].cidr
  single_az_ha  = var.single_az_ha
  fqdn_lan_cidr = aviatrix_transit_gateway.default.lan_interface_cidr
  zone          = var.az_support ? var.az1 : null
}

resource "aviatrix_gateway" "egress_instance_2" {
  count         = var.ha_gw ? (local.is_aviatrix ? 1 : 0) : 0 #If ha is true, and is_aviatrix is true, deploy 1
  cloud_type    = 8
  account_name  = var.account
  gw_name       = "${local.name}-egress-gw2"
  vpc_id        = aviatrix_vpc.default.vpc_id
  vpc_reg       = var.region
  gw_size       = var.fw_instance_size
  subnet        = aviatrix_vpc.default.subnets[3].cidr
  single_az_ha  = var.single_az_ha
  fqdn_lan_cidr = aviatrix_transit_gateway.default.ha_lan_interface_cidr
  zone          = var.az_support ? var.az2 : null
}

resource "aviatrix_firenet" "firenet" {
  vpc_id                               = aviatrix_vpc.default.vpc_id
  inspection_enabled                   = local.is_aviatrix ? false : var.inspection_enabled #Always switch to false if Aviatrix FQDN egress.
  egress_enabled                       = local.is_aviatrix ? true : var.egress_enabled      #Always switch to true if Aviatrix FQDN egress.
  manage_firewall_instance_association = false
  egress_static_cidrs                  = var.egress_static_cidrs
  depends_on = [
    aviatrix_firewall_instance_association.firenet_instance,
    aviatrix_firewall_instance_association.firenet_instance1,
    aviatrix_firewall_instance_association.firenet_instance2,
    aviatrix_gateway.egress_instance,
    aviatrix_gateway.egress_instance_1,
    aviatrix_gateway.egress_instance_2,
  ]
}

resource "aviatrix_firewall_instance_association" "firenet_instance" {
  count                = var.ha_gw ? 0 : 1
  vpc_id               = aviatrix_vpc.default.vpc_id
  firenet_gw_name      = aviatrix_transit_gateway.default.gw_name
  instance_id          = local.is_aviatrix ? aviatrix_gateway.egress_instance[0].gw_name : aviatrix_firewall_instance.firewall_instance[0].instance_id
  firewall_name        = local.is_aviatrix ? null : aviatrix_firewall_instance.firewall_instance[0].firewall_name
  lan_interface        = local.is_aviatrix ? aviatrix_gateway.egress_instance[0].fqdn_lan_interface : aviatrix_firewall_instance.firewall_instance[0].lan_interface
  management_interface = local.is_aviatrix ? null : aviatrix_firewall_instance.firewall_instance[0].management_interface
  egress_interface     = local.is_aviatrix ? null : aviatrix_firewall_instance.firewall_instance[0].egress_interface
  vendor_type          = local.is_aviatrix ? "fqdn_gateway" : null
  attached             = var.attached
}

resource "aviatrix_firewall_instance_association" "firenet_instance1" {
  count                = var.ha_gw ? 1 : 0
  vpc_id               = aviatrix_vpc.default.vpc_id
  firenet_gw_name      = aviatrix_transit_gateway.default.gw_name
  instance_id          = local.is_aviatrix ? aviatrix_gateway.egress_instance_1[0].gw_name : aviatrix_firewall_instance.firewall_instance_1[0].instance_id
  firewall_name        = local.is_aviatrix ? null : aviatrix_firewall_instance.firewall_instance_1[0].firewall_name
  lan_interface        = local.is_aviatrix ? aviatrix_gateway.egress_instance_1[0].fqdn_lan_interface : aviatrix_firewall_instance.firewall_instance_1[0].lan_interface
  management_interface = local.is_aviatrix ? null : aviatrix_firewall_instance.firewall_instance_1[0].management_interface
  egress_interface     = local.is_aviatrix ? null : aviatrix_firewall_instance.firewall_instance_1[0].egress_interface
  vendor_type          = local.is_aviatrix ? "fqdn_gateway" : null
  attached             = var.attached
}

resource "aviatrix_firewall_instance_association" "firenet_instance2" {
  count                = var.ha_gw ? 1 : 0
  vpc_id               = aviatrix_vpc.default.vpc_id
  firenet_gw_name      = aviatrix_transit_gateway.default.ha_gw_name
  instance_id          = local.is_aviatrix ? aviatrix_gateway.egress_instance_2[0].gw_name : aviatrix_firewall_instance.firewall_instance_2[0].instance_id
  firewall_name        = local.is_aviatrix ? null : aviatrix_firewall_instance.firewall_instance_2[0].firewall_name
  lan_interface        = local.is_aviatrix ? aviatrix_gateway.egress_instance_2[0].fqdn_lan_interface : aviatrix_firewall_instance.firewall_instance_2[0].lan_interface
  management_interface = local.is_aviatrix ? null : aviatrix_firewall_instance.firewall_instance_2[0].management_interface
  egress_interface     = local.is_aviatrix ? null : aviatrix_firewall_instance.firewall_instance_2[0].egress_interface
  vendor_type          = local.is_aviatrix ? "fqdn_gateway" : null
  attached             = var.attached
}
