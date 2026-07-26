extends Panel
class_name PurchaseItem

# Managers
@onready var economy_manager: EconomyManager = get_tree().current_scene.get_node("EconomyManager")

@onready var name_panel: Label = $VBoxContainer/NamePanel
@onready var purchase_cost_label: Label = $VBoxContainer/MarginContainer/HBoxContainer/PurchaseButton/PurchaseCostLabel
@onready var purchase_icon: TextureRect = $VBoxContainer/MarginContainer/HBoxContainer/PurchaseIcon
@onready var purchase_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/PurchaseButton

var data

signal on_purchased(item_data)

func setup(item_data):
	data = item_data

func _ready() -> void:
		name_panel.text = data.name
		purchase_icon.texture = data.icon
		purchase_cost_label.text = str(Utils.format_compact_number(data.cost))
		
		var red_style = StyleBoxFlat.new()
		red_style.bg_color = Color(0.45, 0.05, 0.05) # dark red
		
		var green_style = StyleBoxFlat.new()
		green_style.bg_color = Color(0.35, 0.65, 0.45) # soft green
		
		if economy_manager.can_purchase(data.cost):
			purchase_button.add_theme_stylebox_override("normal", green_style)
		else:
			purchase_button.add_theme_stylebox_override("normal", red_style)


func _on_purchase_button_button_down() -> void:
	if economy_manager.can_purchase(data.cost):
		on_purchased.emit(data)
