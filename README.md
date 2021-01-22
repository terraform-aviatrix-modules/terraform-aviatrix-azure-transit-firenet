# Aviatrix Transit Firenet for Azure

### Description
This module deploys a VNET, Aviatrix transit gateways (HA), and firewall instances.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v3.0.0 | 0.13 | >=6.2 | >=2.17.2
v2.0.2 | 0.12 | >=6.2 | >=2.17.1
v2.0.1 | 0.12 | >=6.2 | >=2.17
v2.0.0 | 0.12 | >=6.2 | >=2.17
v1.0.2 | 0.12 | 6.1 | 2.16, 2.16.1
v1.0.2 | 0.12 | 6.0 | 2.15, 2.15.1

**_Information on older releases can be found in respective release notes._*

### Diagram
<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-azure-transit-firenet/blob/master/img/azure-transit-firenet.png?raw=true">

### Usage Example

Examples shown below are specific to each vendor.

#### Palo Alto Networks
```
module "transit_firenet_1" {
  source                 = "terraform-aviatrix-modules/azure-transit-firenet/aviatrix"
  version                = "3.0.0"
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
  version                = "3.0.0"
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
  version                = "3.0.0"
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
firewall_image | String for the firewall image to use
firewall_image_version | The firewall image version specific to the NGFW vendor image

Firewall images
```
Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1 
Check Point CloudGuard IaaS Single Gateway R80.40 - Bring Your Own License
Fortinet FortiGate (BYOL) Next-Generation Firewall
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
instance_size | Standard_B2ms | Size of the transit gateway instances. **Insane mode requires a minimum Standard_D3_v2 instance size**
fw_instance_size | Standard_D3_v2 | Size of the firewall instances
attached | true | Attach firewall instances to Aviatrix Gateways
firewall_username | fwadmin | Default username for administrative account on the firewall. **_For Check Point firewalls it will always default to admin_**. Admin is not allowed for other image types. Should not contain special chars.
ha_gw | true | Set to false to deploy single Aviatrix gateway. When set to false, fw_amount is ignored and only a single NGFW instance is deployed.
password | Aviatrix#1234 | Default initial password for firewall instances
insane_mode | false | Set to true to enable Aviatrix insane mode high-performance encryption 
name | null | When this string is set, user defined name is applied to all infrastructure supporting n+1 sets within a same region or other customization
egress_enabled | false | Set to true to enable egress inspection on the firewall instances
inspection_enabled | true | Set to false to disable inspection on the firewall instances
connected_transit | true | Set to false to disable connected_transit
bgp_manual_spoke_advertise_cidrs | | Intended CIDR list to advertise via BGP. Example: "10.2.0.0/16,10.4.0.0/16" 
learned_cidr_approval | false | Switch to true to enable learned CIDR approval
active_mesh | true | Set to false to disable active_mesh
prefix | true | Boolean to enable prefix name with avx-
suffix | true | Boolean to enable suffix name with -firenet
enable_segmentation | false | Switch to true to enable transit segmentation
insane_instance_size | Standard_D3_v2 | Instance size used when insane mode is enabled.
enable_egress_transit_firenet | false | Switch to true to enable egress on the transit firenet.
single_az_ha | true | Set to false if Controller managed Gateway HA is desired
single_ip_snat | false | Enable single_ip mode Source NAT for this container
enable_advertise_transit_cidr  | false | Switch to enable/disable advertise transit VPC network CIDR for a VGW connection
bgp_polling_time  | 50 | BGP route polling time. Unit is in seconds
bgp_ecmp  | false | Enable Equal Cost Multi Path (ECMP) routing for the next hop
bootstrap_storage_name | null | Storagename to get bootstrap files from (PANW only)
storage_access_key | null | Storage_access_key to access bootstrap storage (PANW only)
file_share_folder | null | Name of the folder containing the bootstrap files (PANW only)

### Outputs
This module will return the following objects:

key | description
:--- | :---
vpc | The created VNET as an object with all of it's attributes. This was created using the aviatrix_vpc resource.
transit_gateway | The created Aviatrix transit gateway as an object with all of it's attributes.
aviatrix_firenet | The created Aviatrix firenet object with all of it's attributes.
aviatrix_firewall_instance | A list of the created firewall instances and their attributes.
azure_rg | The name of the Azure resource group that the Aviatrix infrastructure created in
azure_vnet_name | The name of the Azure vnet created
firewall_instance_nic_names | The names of the NICs of the firewall(s)
fw_name | A list of the firewall names created


#### Azure Infrastructure Created

The module automates creation of 44 infrastructure components in Azure.

<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-azure-transit-firenet/blob/master/img/azure-firenet-module-infr.png?raw=true">

