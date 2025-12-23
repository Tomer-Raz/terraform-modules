####jason #####

{
    "venthub_authorization_rul" : {
                "eventhub_authorization_rule_1" : {
                    "name"                     : "listen",
                    "namespace_name"           : "we-dprd-lang-opxa-namesp-evhns",
                    "eventhub_name"            : "we-dprd-lang-opxa-nameevhub-evh",
                    "resource_group_name"      : "realtrm-rg",
                    "listen"                   : true,
                    "send"                     : false,
                    "manage"                   : false

                },
                "eventhub_authorization_rule_2" : {
                    "name"                     : "listen",
                    "namespace_name"           : "we-dprd-lang-opxa-namesp-evhns",
                    "eventhub_name"            : "we-dprd-lang-opxa-nameevhub-evh",
                    "resource_group_name"      : "realtrm-rg",
                    "listen"                   : true,
                    "send"                     : true,
                    "manage"                   : true

                }





    }





#####run command

module "azurerm_eventhub_authorization_rule" {
    source              = "./moudle/azurerm_eventhub_authorization_rule"

    eventhub_authorization_rule  = local.local_authentication_enabled.venthub_authorization_rul
}




}

