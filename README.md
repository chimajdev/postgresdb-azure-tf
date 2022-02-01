modules 
    main.tf         -- Actual code
    variables.tf    -- Variables for the terraform module
    output.tf       -- Output variables to print on terraform apply
    version.tf      -- Shows compatible versions for the module

=====

module -- standard template of postgres, no hardcoding and called from outside main.tf


====

Changes

variables.tf 
    subnet_id

main.tf
    postgresql_server_name
    sku_name
    storage_mb
    version
    database_name
    backup_retention_days
    email_addresses_for_alerts
    ad_admin_login_name
    desktop-ip 
    tags
    name = "jospeh-postgres" [line 99]