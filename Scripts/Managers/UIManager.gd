extends Node
class_name UIManager

# signals
signal on_player_click_on_tree

# Managers
@onready var economy_manager: EconomyManager = get_tree().current_scene.get_node("EconomyManager")
@onready var tree_manager: TreeManager = get_tree().current_scene.get_node("TreeManager")
@onready var purchase_manager: PurchaseManager = get_tree().current_scene.get_node("PurchaseManager")

# Nodes
@onready var texture_button: TextureButton = $"../HBoxContainer/LeftPanel/MarginContainer/CenterContainer/TextureButton"
@onready var current_tree_hp_bar: ProgressBar = $"../HBoxContainer/LeftPanel/MarginContainer/Stats/Container/CurrentTreeHPBar"
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var tree_remaining_label: Label = $"../HBoxContainer/LeftPanel/MarginContainer/Stats/TextureRect/TreeRemainingLabel"
@onready var farmers_container: VBoxContainer = $"../HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Farmers/ScrollContainer/FarmersContainer"
@onready var gold_label: Label = $"../HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Control/HBoxContainer/GoldLabel"
@onready var menu_dialog: Control = $"../MenuDialog"

var button_scene: PackedScene = preload("uid://d1xqtaxjiigr6")

var all_farmers = []

func init_farmers_data():
	for i in range(10):
		all_farmers.append(load("res://Data/Farmers/ch_%d.tres" % (i + 1)))
		
func init_ui():
	menu_dialog.visible = false
	init_farmers_data()
	
	update_ui_player_gold()
	update_ui_tree_remaining()
	update_ui_current_tree_hp()
	update_ui_farmers()
	
	
func _ready() -> void:
	economy_manager.on_gold_changed.connect(update_ui_player_gold)
	economy_manager.on_gold_changed.connect(update_ui_farmers)
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
	gold_label.text = str(Utils.format_compact_number(economy_manager.gold))
	
func update_ui_tree_remaining():
	
	tree_remaining_label.text = Utils.format_with_spaces(max(tree_manager.total_trees_on_earth-tree_manager.total_trees_cut_down, 0))

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
		hbox.add_theme_constant_override("separation", 10)
		hbox.anchor_right = 1.0
		hbox.anchor_bottom = 1.0
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
		var count_label = Label.new()
		count_label.text = "x 0"
		count_label.custom_minimum_size = Vector2(30, 0)  # largeur fixée, hauteur automatique
		var amount_farmer = 0
		
		for it_owned_farmer in purchase_manager.owned_farmers.values():
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
	purchase_manager.add_item(data)


func _on_main_menu_button_button_down() -> void:
	Utils.open_scene(GameEnum.Scene.MAIN_MENU)


func _on_continue_button_button_down() -> void:
	menu_dialog.visible = false


func _on_open_dialog_menu_button_button_down() -> void:
	menu_dialog.visible = true
