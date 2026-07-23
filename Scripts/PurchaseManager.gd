extends Node

# variables
var owned_farmers = {}
var owned_upgrades = []

func add_item(item_data):
	if item_data is Farmer:
		if owned_farmers.has(item_data.id):
			owned_farmers[item_data.id]["amount"] += 1
		else:
			owned_farmers[item_data.id] = {
				"data": item_data,
				"amount": 1
			}
	elif item_data is Upgrade:
		owned_upgrades.append(item_data)
		
	# used to update UI 
	EconomyManager.emit_signal("gold_changed")
	
