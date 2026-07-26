extends Node
class_name EconomyManager

@onready var ui_manager: UIManager = get_tree().current_scene.get_node("UIManager")

# signals
signal on_gold_changed

# variables
var gold: float = 0

func add_gold(amount: float = 1):
	gold += amount
	on_gold_changed.emit()
	
func can_purchase(amount: float):
	return gold >= amount
