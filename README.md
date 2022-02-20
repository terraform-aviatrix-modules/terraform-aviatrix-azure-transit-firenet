# Aviatrix Transit Firenet for Azure

### Description
This module deploys a VNET, Aviatrix transit gateways (HA), and firewall instances.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v5.0.0 | 0.13 - 1.x | >=6.6 | 2.21.0-6.6.ga
v4.0.3 | 0.13 + 0.14 | >=6.4 | >=0.2.19
v4.0.0 | 0.13 + 0.14 | >=6.4 | >=0.2.19

**_Information on older releases can be found in respective release notes._*

### Diagram
<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-azure-transit-firenet/blob/master/img/azure-transit-firenet.png?raw=true">

### Usage Example

Examples shown below are specific to each vendor.

#### Palo Alto Networks
```
module "transit_firenet_1" {
  source                 = "terraform-aviatrix-modules/azure-transit-firenet/aviatrix"
  version                = "5.0.0"
  cidr                   = "10.1.0.0/20"
  region                 = "East US"
  account                = "Azure"
  firewall_image         = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  firewall_image_version = "9.1.0"
}
```
#### Check Point

```
module "transit_firenet_1" {
  source                 = "terraform-aviatrix-modules/azure-transit-firenet/aviatrix"
  version                = "5.0.0"
  cidr                   = "10.1.0.0/20"
  region                 = "East US"
  account                = "Azure"
  firewall_image         = "Check Point CloudGuard IaaS Single Gateway R80.40 - Bring Your Own License" 
  firewall_image_version = "8040.900294.0593"
}
```

#### Fortinet
```
module "transit_firenet_1" {
  source                 = "terraform-aviatrix-modules/azure-transit-firenet/aviatrix"
  version                = "5.0.0"
  cidr                   = "10.1.0.0/20"
  region                 = "East US"
  account                = "Azure"
  firewall_image         = "Fortinet FortiGate (BYOL) Next-Generation Firewall"
  firewall_image_version = "6.4.1"
}
```

### Variables
The following variables are required:

key | value
--- | ---
region | Azure region to deploy the transit VNET in
account | The Azure access account on the Aviatrix controller, under which the controller will deploy this VNET
cidr | The IP CIDR wo be used to create the VNET
firewall_image | String for the firewall image to use (Optional when deploy_firenet = false)
firewall_image_version | The firewall image version specific to the NGFW vendor image (Optional when choosing Aviatrix FQDN egress or when deploy_firenet = false)

Firewall images
```
Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1 
Check Point CloudGuard IaaS Single Gateway R80.40 - Bring Your Own License
Fortinet FortiGate (BYOL) Next-Generation Firewall
Aviatrix FQDN Egress Filtering
```

Firewall image versions tested
```
Palo Alto Networks - 9.1.0
Check Point        - 8040.900294.0593
Fortinet           - 6.4.1
```

The following variables are optional:

key | default | value
:--- | :--- | :---
active_mesh | true | Set to false to disable active_mesh
attached | true | Attach firewall instances to Aviatrix Gateways
az_support | true | Set to false if the Azure region does not support Availability Zones.
az1 | az-1 | AZ Zone to be used for Transit GW + NGFW deployment.
az2 | az-2 | AZ Zone to be used for HA Transit GW + HA NGFW deployment.
bgp_ecmp  | false | Enable Equal Cost Multi Path (ECMP) routing for the next hop
bgp_manual_spoke_advertise_cidrs | | Intended CIDR list to advertise via BGP. Example: "10.2.0.0/16,10.4.0.0/16" 
bgp_polling_time  | 50 | BGP route polling time. Unit is in seconds
bootstrap_storage_name_1 | null | Storagename to get bootstrap files from (PANW only). (If bootstrap_storage_name_2 is not set, this will used for all NGFW instances)
bootstrap_storage_name_2 | null | Storagename to get bootstrap files from (PANW only) (Only used when HA FW instance is deployed)
connected_transit | true | Set to false to disable connected_transit
deploy_firenet | true | Set to false to only deploy the Transit, but without the actual NGFW instances and Firenet settings (e.g. if you want to deploy that later or manually).
east_west_inspection_excluded_cidrs | | Network List Excluded From East-West Inspection.
egress_enabled | false | Set to true to enable egress inspection on the firewall instances
egress_static_cidrs | [] | List of egress static CIDRs. Egress is required to be enabled. Example: ["1.171.15.184/32", "1.171.15.185/32"].
enable_advertise_transit_cidr  | false | Switch to enable/disable advertise transit VPC network CIDR for a VGW connection
enable_bgp_over_lan | false | Enable BGp over LAN. Creates eth4 for integration with SDWAN for example
enable_egress_transit_firenet | false | Set to true to enable egress on transit gw
enable_egress_transit_firenet | false | Switch to true to enable egress on the transit firenet.
enable_multi_tier_transit |	false |	Switch to enable multi tier transit
enable_segmentation | false | Switch to true to enable transit segmentation
fail_close_enabled | | Set to true to enable fail close
file_share_folder_1 | null | Name of the folder containing the bootstrap files (PANW only) (If file_share_folder_2 is not set, this will used for all NGFW instances)
file_share_folder_2 | null | Name of the folder containing the bootstrap files (PANW only) (Only used when HA FW instance is deployed)
firewall_image_id | | Custom Firewall image ID.
firewall_username | fwadmin | Default username for administrative account on the firewall. **_For Check Point firewalls it will always default to admin_**. Admin is not allowed for other image types. Should not contain special chars.
fw_amount | 2 | The amount of NGFW instances to deploy. These will be deployed accross multiple AZ's. Amount must be even and only applies to when ha_gw enabled.
fw_instance_size | Standard_D3_v2 | Size of the firewall instances
fw_tags | null | Map of tags to assign to the firewall or FQDN egress gw's.
gov | false | Set to true if deploying this module in Azure GOV.
ha_gw | true | Set to false to deploy single Aviatrix gateway. When set to false, fw_amount is ignored and only a single NGFW instance is deployed.
insane_instance_size | Standard_D3_v2 | Instance size used when insane mode is enabled.
insane_mode | false | Set to true to enable Aviatrix insane mode high-performance encryption 
inspection_enabled | true | Set to false to disable inspection on the firewall instances
instance_size | Standard_B2ms | Size of the transit gateway instances. **Insane mode requires a minimum Standard_D3_v2 instance size**
learned_cidr_approval | false | Switch to true to enable learned CIDR approval
learned_cidrs_approval_mode | | Learned cidrs approval mode. Defaults to Gateway. Valid values: gateway, connection
local_as_number | | Changes the Aviatrix Transit Gateway ASN number before you setup Aviatrix Transit Gateway connection configurations.
name | null | When this string is set, user defined name is applied to all infrastructure supporting n+1 sets within a same region or other customization
password | Aviatrix#1234 | Default initial password for firewall instances
prefix | true | Boolean to enable prefix name with avx-
resource_group | null | Provide the name of an existing resource group.
single_az_ha | true | Set to false if Controller managed Gateway HA is desired
single_ip_snat | false | Enable single_ip mode Source NAT for this container
storage_access_key_1 | null | Storage_access_key to access bootstrap storage (PANW only) (If storage_access_key_2 is not set, this will used for all NGFW instances)
storage_access_key_2 | null | Storage_access_key to access bootstrap storage (PANW only) (Only used when HA FW instance is deployed)
suffix | true | Boolean to enable suffix name with -firenet
tags | null | Map of tags to assign to the gateway.
tunnel_detection_time | null | The IPsec tunnel down detection time for the Spoke Gateway in seconds. Must be a number in the range [20-600]. Default is 60.
user_data_1 | | User data for bootstrapping Fortigate and Checkpoint firewalls. (If user_data_2 is not set, this will used for all NGFW instances)
user_data_2 | | User data for bootstrapping Fortigate and Checkpoint firewalls. (Only used if 2 or more FW instances are deployed, e.g. when ha_gw is true. Applies to "even" fw instances (2,4,6 etc))


### Outputs
This module will return the following objects:

key | description
:--- | :---
[vnet](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_vpc) | The created VNET as an object with all of it's attributes. This was created using the aviatrix_vpc resource.
[transit_gateway](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_transit_gateway) | The created Aviatrix transit gateway as an object with all of it's attributes.
[aviatrix_firenet](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_firenet) | The created Aviatrix firenet object with all of it's attributes.
[aviatrix_firewall_instance](https://registry.terraform.io/providers/AviatrixSystems/aviatrix/latest/docs/resources/aviatrix_firewall_instance) | A list of the created firewall instances and their attributes.
azure_rg | The name of the Azure resource group that the Aviatrix infrastructure created in
azure_vnet_name | The name of the Azure vnet created

