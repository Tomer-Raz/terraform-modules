# terraform-azurerm-subscriptions

# add to root JSON the following section
```terraform
{
    "subscription_details": {
        "name":"",
        "billing_account_name": "",
        "enrollment_account_name":""
    }
}
```

# run the module with simular code

```terraform
locals {
    subscription = jsondecode(file("./foundation/subscription.json"))
}

module "subscription" {
  source = "./modules/terraform-azurerm-suibscription"
  subscription_details   = local.subscription.subscription_details
  tags= [{tag...}]
}
```