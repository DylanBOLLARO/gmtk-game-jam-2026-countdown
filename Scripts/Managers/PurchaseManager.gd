extends Node
class_name PurchaseManager

@onready var economy_manager: EconomyManager = get_tree().current_scene.get_node("EconomyManager")
@onready var tree_manager: TreeManager = get_tree().current_scene.get_node("TreeManager")

# variables
var owned_farmers = {}
var owned_upgrades = []

func add_item(item_data):
	if item_data is Farmer:
		if owned_farmers.has(item_data.type):
			owned_farmers[item_data.type]["amount"] += 1
		else:
			owned_farmers[item_data.type] = {
				"data": item_data,
				"amount": 1
			}
	economy_manager.on_gold_changed.emit()
	
func _process(delta: float) -> void:
	for it_farmer in owned_farmers.keys():
		var data = owned_farmers[it_farmer].get("data")
		var amount = owned_farmers[it_farmer].get("amount")
		tree_manager.hit_tree(data.damage * amount * delta)
