extends Node
class_name UIManager

# signals
signal on_player_click_on_tree

# Managers
@onready var economy_manager: EconomyManager = get_tree().current_scene.get_node("EconomyManager")
@onready var tree_manager: TreeManager = get_tree().current_scene.get_node("TreeManager")
@onready var money_per_sec_label: Label = $"../HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/MoneyPerSecLabel"
@onready var texture_button: TextureButton = $"../HBoxContainer/LeftPanel/MarginContainer/CenterContainer/TextureButton"
@onready var tree_remaining_label: Label = $"../HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/TreeRemainingLabel"
@onready var current_tree_hp: Label = $"../HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/CurrentTreeHP"
@onready var current_tree_hp_bar: ProgressBar = $"../HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/CurrentTreeHPBar"
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var gold_label: Label = $"../HBoxContainer/RightPanel/MarginContainer/VBoxContainer/HBoxContainer/GoldLabel"

@onready var farmers_container: VBoxContainer = $"../HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Farmers/ScrollContainer/FarmersContainer"

var button_scene: PackedScene = preload("uid://d1xqtaxjiigr6")

var all_farmers = [
	preload("res://Data/Farmers/Minotaur.tres"),
	preload("res://Data/Farmers/Woodcutter.tres"),
	preload("res://Data/Farmers/Woodcutter2.tres"),
	preload("res://Data/Farmers/Woodcutter3.tres"),
	preload("res://Data/Farmers/Woodcutter4.tres"),
	preload("res://Data/Farmers/Woodcutter5.tres"),
	preload("res://Data/Farmers/Woodcutter6.tres"),
	preload("res://Data/Farmers/Woodcutter7.tres"),
]

func init_ui():
	update_ui_player_gold()
	update_ui_tree_remaining()
	update_ui_current_tree_hp()
	update_ui_farmers()
	
func _ready() -> void:
	economy_manager.on_gold_changed.connect(update_ui_player_gold)
	economy_manager.on_gold_changed.connect(update_ui_farmers)
	tree_manager.on_total_trees_cut_down_changed.connect(update_ui_tree_remaining)
	texture_button.pivot_offset = texture_button.size / 2
	
	init_ui()
	
func _on_texture_button_button_down() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(texture_button,"scale",Vector2(.9,.9),.03)
	on_player_click_on_tree.emit()
	audio_stream_player.play()
	
func _on_texture_button_button_up() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(texture_button,"scale",Vector2(1,1),.03)

func update_ui_player_gold():
	gold_label.text = str(round((economy_manager.gold)))
	
func format_with_spaces(number: int) -> String:
	var s = str(number)
	var result = ""
	var count = 0
	for i in range(s.length() - 1, -1, -1):
		result = s[i] + result
		count += 1
		if count % 3 == 0 and i != 0:
			result = " " + result
	return result
	
func update_ui_tree_remaining():
	tree_remaining_label.text = format_with_spaces(tree_manager.total_trees_on_earth-tree_manager.total_trees_cut_down)

func update_ui_current_tree_hp():
	current_tree_hp_bar.max_value = tree_manager.current_tree_max_hp
	current_tree_hp_bar.value = tree_manager.current_tree_hp
	
func update_ui_farmers():
	#remove all items in list
	for child in farmers_container.get_children():
		child.queue_free()
	
	var sorted = all_farmers.duplicate()

	sorted.sort_custom(func(a, b):
		return a.cost < b.cost
	)
	
	# generate all items in list
	for item in sorted:
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 30)
		hbox.anchor_right = 1.0
		hbox.anchor_bottom = 1.0
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
		var count_label = Label.new()
		count_label.text = "x 0"
		
		var amount_farmer = 0
		
		for it_owned_farmer in PurchaseManager.owned_farmers.values():
			if item.type == it_owned_farmer.get("data").type:
				amount_farmer = it_owned_farmer.get("amount")
		
		if amount_farmer > 0 :
			count_label.text = "x " + str(amount_farmer)
			
		var button_instance:PurchaseItem = button_scene.instantiate()
		button_instance.setup(item)
		button_instance.on_purchased.connect(on_item_purchased)
		
		hbox.add_child(button_instance)
		hbox.add_child(count_label)
		farmers_container.add_child(hbox)
		
func on_item_purchased(data):
	economy_manager.add_gold(data.cost * -1)
	PurchaseManager.add_item(data)
