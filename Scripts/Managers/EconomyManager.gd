extends Node
class_name EconomyManager

@onready var ui_manager: UIManager = get_tree().current_scene.get_node("UIManager")

# signals
signal on_gold_changed

# variables
var gold: float = 0
var gold_gained_this_second: float = 0

# TODO to remove, only for dev/testing
func _ready() -> void:
	ui_manager.on_player_click_on_tree.connect(add_gold.bind(50.0))
	
func add_gold(amount: float = 1):
	gold += amount
	
	if amount > 0:
		gold_gained_this_second += amount
		
	on_gold_changed.emit()
	
func can_purchase(amount: float):
	return gold >= amount
