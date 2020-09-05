# Aviatrix Transit Firenet for Azure

### Description
This module deploys a VNET, Aviatrix transit gateways (HA), and firewall instances.

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.2 | 0.12 | 6.1 | 2.16, 2.16.1
v1.0.2 | 0.12 | 6.0 | 2.15, 2.15.1
v1.0.1 | 0.12 | |
v1.0.0 | 0.12 | |

### Diagram
<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-azure-transit-firenet/blob/master/img/azure-transit-firenet.png?raw=true">

### Usage Example

Examples shown below are specific to each vendor.

#### Palo Alto Networks
```
module "transit_firenet_1" {
  source                 = "terraform-aviatrix-modules/azure-transit-firenet/aviatrix"
  version                = "1.0.1"
  cidr                   = "10.1.0.0/20"
  region                 = "East Us"
  account                = "Azure"
  firewall_image         = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  firewall_image_version = "9.1.0"
}
```
#### Check Point
```
module "transit_firenet_1" {
  source                 = "terraform-aviatrix-modules/azure-transit-firenet/aviatrix"
  version                = "1.0.1"
  cidr                   = "10.1.0.0/20"
  region                 = "East Us"
  account                = "Azure"
  firewall_image         = "Check Point CloudGuard IaaS Single Gateway R80.40 - Bring Your Own License" 
  firewall_image_version = "8040.900294.0593"
}
```


#### Fortinet
```
module "transit_firenet_1" {
  source                 = "terraform-aviatrix-modules/azure-transit-firenet/aviatrix"
  version                = "1.0.1"
  cidr                   = "10.1.0.0/20"
  region                 = "East Us"
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
firewall_username | fwadmin | Default username for administrative account on the firewall. For Check Point firewalls it will always default to admin. Admin is not allowed for other image types. Should not contain special chars.
ha_gw | true | Set to false to deploy single Aviatrix gateway. When set to false, fw_amount is ignored and only a single NGFW instance is deployed.
checkpoint_password | Aviatrix#1234 | Default initial password for Check Point, only required when using Check Point image
insane_mode | false | Set to true to enable Aviatrix insane mode high-performance encryption 
name | null | When this string is set, user defined name is applied to all infrastructure supporting n+1 sets within a same region or other customization
egress_enabled | false | Set to true to enable egress inspection on the firewall instances
inspection_enabled | true | Set to false to disable inspection on the firewall instances
connected_transit | true | Set to false to disable connected_transit
active_mesh | true | Set to false to disable active_mesh

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

