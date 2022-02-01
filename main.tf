provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

module "postgresql-db" {
  source  = "./module"

  # By default, this module will create a resource group
  # proivde a name to use an existing resource group and set the argument 
  # to `create_resource_group = false` if you want to existing resoruce group. 
  # If you use existing resrouce group location will be the same as existing RG.
  create_resource_group = false
  resource_group_name   = "app-rg"
  location              = "eastus"

  # PostgreSQL Server and Database settings
  postgresql_server_name = "postgresdbsrv01" # change

  postgresql_server_settings = {
    sku_name   = "GP_Gen5_8" # change the disk type
    storage_mb = 640000 # change the storage size
    version    = "9.6" # change db version
    # default admin user `postgresadmin` and can be specified as per the choice here
    # by default random password created by this module. required password can be specified here
    admin_username = var.admin_username
    admin_password = var.admin_password
    #admin_password = "aDmIn#125"
    # Database name, charset and collection arguments  
    database_name = "postgres-db" #change
    charset       = "UTF8"
    collation     = "English_United States.1252"
    # Storage Profile and other optional arguments
    auto_grow_enabled                = true
    backup_retention_days            = 7      # change for how many days back should be there
    geo_redundant_backup_enabled     = true
    public_network_access_enabled    = true
    ssl_enforcement_enabled          = true
    ssl_minimal_tls_version_enforced = "TLS1_2"
  }

  # PostgreSQL Server Parameters 
  postgresql_configuration = {
    backslash_quote = "on"
  }

  # Use Virtual Network service endpoints and rules for Azure Database for PostgreSQL
  subnet_id = var.subnet_id  

  # The URL to a Key Vault custom managed key
  # key_vault_key_id = var.key_vault_key_id

  # To enable Azure Defender for database set `enable_threat_detection_policy` to true 
  enable_threat_detection_policy = true
  log_retention_days             = 30
  email_addresses_for_alerts     = ["sushantmore0628@gmail.com",""] # change email

  # AD administrator for an Azure database for PostgreSQL
  # Allows you to set a user or group as the AD administrator for PostgreSQL server
  ad_admin_login_name = "sushantmore0628@gmail.com" # change this

  # (Optional) To enable Azure Monitoring for Azure PostgreSQL database
  # (Optional) Specify `storage_account_name` to save monitoring logs to storage. 
  #log_analytics_workspace_name = "loganalytics-we-sharedtest2"

  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.mysql.database.azure.com` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  # enable_private_endpoint       = false
  # virtual_network_name          = "vnet-shared-hub-westeurope-001"
  # private_subnet_address_prefix = ["10.1.5.0/29"]
  #  existing_private_dns_zone     = "demo.example.com"

  # Firewall Rules to allow azure and external clients and specific Ip address/ranges. 
  firewall_rules = {
    access-to-azure = {
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    },
    desktop-ip = {
      start_ip_address = "49.204.228.223" # This is IP if you want external communication to be enabled
      end_ip_address   = "49.204.228.223"
    }
  }

  # Tags for Azure Resources
  tags = {
    Name        = "postgres-db" # change
    Environment = "dev" # change
  }
}

# Store password to key vault
data "azurerm_key_vault" "azvault" {
  name                = "jospeh-postgres" # change
  resource_group_name = "app-rg"  # change
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "postgres-password" 
  value        = var.admin_password
  key_vault_id = data.azurerm_key_vault.azvault.id
}

# resource "azurerm_key_vault_secret" "username" {
#   name         = "postgres-username" 
#   value        = var.admin_username
#   key_vault_id = data.azurerm_key_vault.azvault.id
# }

# resource "azurerm_key_vault_secret" "db_fqdn" {
#   name         = "postgres-fqdn" 
#   value        = module.postgresql-db.postgresql_server_fqdn
#   key_vault_id = data.azurerm_key_vault.azvault.id
# }


