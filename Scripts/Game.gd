extends Control

# Manager
@onready var tree_manager: TreeManager = $TreeManager
@onready var ui_manager: UIManager = $UIManager
@onready var economy_manager: EconomyManager = $EconomyManager

# Nodes
@onready var gold_label: Label = $HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/GoldLabel
@onready var farmers_container: VBoxContainer = $HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Farmers/FarmersContainer
@onready var upgrades_container: VBoxContainer = $HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Upgrades/UpgradesContainer
@export var button_scene: PackedScene
@onready var money_per_sec_label: Label = $HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/MoneyPerSecLabel
@onready var tree_remaining_label: Label = $HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/TreeRemainingLabel

var player_damage: float = 1

# --- handle farmers 
var amount_farm_multiplier: float = 1

var timer := Timer.new()

var all_farmers = [
	preload("res://Data/Farmers/Minotaur.tres"),
	preload("res://Data/Farmers/Woodcutter.tres"),
]

var all_upgrades = [
	preload("res://Data/Upgrades/BetterAx.tres"),
	preload("res://Data/Upgrades/MinotaurBetterWeapon.tres"),
	preload("res://Data/Upgrades/WoodcutterBetterWeapon.tres"),
]


func update_ui_gold():
	pass
	#gold_label.text = str(economy_manager.gold)

#func generate_all_upgrades():
	##remove all items in list
	#for child in upgrades_container.get_children():
		#child.queue_free()
	#
	#var sorted = all_upgrades.duplicate()
#
	#sorted.sort_custom(func(a, b):
		#return a.cost < b.cost
	#)
	#
	## generate all items in list
	#for item in sorted:
		#var owned := false
#
		#for upgrade in PurchaseManager.owned_upgrades:
			#if upgrade["name"] == item.name:
				#owned = true
				#break
#
		#if owned:
			#continue
#
		#var hbox = HBoxContainer.new()
		#hbox.anchor_right = 1.0
		#hbox.anchor_bottom = 1.0
		#hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#
		#var button_instance:PurchaseItem = button_scene.instantiate()
		#button_instance.setup(item)
		#hbox.add_child(button_instance)
		#
		#button_instance.on_purchased.connect(simple_print)
		#upgrades_container.add_child(hbox)
		#

	
func generate_all_farmers():
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
	
func _ready() -> void:
	economy_manager.on_gold_changed.connect(generate_all_farmers)
	#economy_manager.on_gold_changed.connect(generate_all_upgrades)
