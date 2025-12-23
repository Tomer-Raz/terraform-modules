# add to root JSON the following section

[
    {
        "parent":  "",
        "name":  "root-management-group-02",
        "level": 0
    },
    {
        "parent":  "",
        "name":  "root-management-group-01",
        "level": 0
    },
    {
        "parent":  "root-management-group-01",
        "name":  "second-child-root-management-group-01",
        "level": 1
    },
    {
        "parent":  "second-child-root-management-group-01",
        "name":  "second-grandchild-root-management-group-01",
        "level": 2
    },
    {
        "parent":  "second-child-root-management-group-01",
        "name":  "first-grandchild-root-management-group-01",
        "level": 2
    },
    {
        "parent":  "first-grandchild-root-management-group-01",
        "name":  "first-grandgrandchild-root-management-group-01",
        "level": 3
    },
    {
        "parent":  "root-management-group-01",
        "name":  "third-child-root-management-group-01",
        "level": 1
    },
    {
        "parent":  "root-management-group-01",
        "name":  "first-child-root-management-group-01",
        "level": 1
    }
]

# run the module with simular code

module "management_group" {
  source           = "./modules/managment_group"
  data = "${path.module}/ccoe/management_groups.json"
}
