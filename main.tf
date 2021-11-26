terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  
  backend "azurerm" {
        resource_group_name  = "devopsprod"
        storage_account_name = "vsterradata"
        container_name       = "vsdata"
        key                  = "terraform.tfstate"
    }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#resource "azurerm_resource_group" "example" {
#  name     = "helloazurevs004-tf"
#  location = "Central US"
#}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "kubeshow-one"
  location            = "Central US"
  resource_group_name = "devopsprod"
  dns_prefix          = "exampleaks4"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
    enable_auto_scaling = true
    max_count = 7
    min_count = 2
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}