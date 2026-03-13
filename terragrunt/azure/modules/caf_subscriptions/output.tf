output "subscription1" {
  value = {
    name = data.azurerm_subscription.sub1.display_name
    id   = data.azurerm_subscription.sub1.subscription_id
  }
}