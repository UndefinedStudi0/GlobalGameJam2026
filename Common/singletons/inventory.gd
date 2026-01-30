extends Node

signal inventory_updated

# Array to store inventory items
var items: Array = []

func update_inventory():
	var inventory = get_tree().current_scene.find_child("InventoryUi")
	if inventory:
		inventory.populate_inventory(items)

# Add an item to the inventory
func add_item(item: String) -> void:
	if item not in items:
		items.append(item)
	
	update_inventory()

# Remove an item from the inventory
func remove_item(item: String) -> void:
	if item in items:
		items.erase(item)
		
	update_inventory()

# Check if an item is in the inventoryengin
func has_item(item: String) -> bool:
	return item in items

# Debug: Print the inventory
func print_inventory() -> void:
	print("Current Inventory:", items)

# Check if some items are in the user's inventory
func has_required_items(required_items: Array) -> bool:
	# Check if all elements in `required_items` exist in `items`
	for item in required_items:
		if item not in items:
			return false
	return true
