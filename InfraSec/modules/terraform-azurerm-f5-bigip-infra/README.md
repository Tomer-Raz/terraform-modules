# github repo

url : https://github.com/F5Networks/terraform-provider-bigip/tree/master
F5Network scripts version 1.2.17

## variables

# "image_name"

After finding the image to use with the Azure CLI with a variant of the following;

az vm image list --publisher f5-networks --all -f better

{
"offer": "f5-big-ip-better",
"publisher": "f5-networks",
"sku": "f5-bigip-virtual-edition-25m-better-hourly",
"urn": "f5-networks:f5-big-ip-better:f5-bigip-virtual-edition-25m-better-hourly:14.1.404001",
"version": "14.1.404001"
}

f5_image_name is equivalent to the "sku" returned.

# "f5_version"

After finding the image to use with the Azure CLI with a variant of the following;

az vm image list --publisher f5-networks --all -f better

{
"offer": "f5-big-ip-better",
"publisher": "f5-networks",
"sku": "f5-bigip-virtual-edition-25m-better-hourly",
"urn": "f5-networks:f5-big-ip-better:f5-bigip-virtual-edition-25m-better-hourly:14.1.404001",
"version": "14.1.404001"
}

f5_version is equivalent to the "version" returned.

# "product_name"
After finding the image to use with the Azure CLI with a variant of the following;

az vm image list --publisher f5-networks --all -f better

{
"offer": "f5-big-ip-better",
"publisher": "f5-networks",
"sku": "f5-bigip-virtual-edition-25m-better-hourly",
"urn": "f5-networks:f5-big-ip-better:f5-bigip-virtual-edition-25m-better-hourly:14.1.404001",
"version": "14.1.404001"
}

f5_product_name is equivalent to the "offer" returned.


# "user_identity" 
"The ID of the managed user identity to assign to the BIG-IP instance"


# external_enable_ip_forwarding 
"Enable IP forwarding on the External interfaces. To allow inline routing for backends, this must be set to true"
