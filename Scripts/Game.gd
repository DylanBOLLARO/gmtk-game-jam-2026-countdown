extends Control

# Manager
@onready var tree_manager: TreeManager = $TreeManager
@onready var ui_manager: UIManager = $UIManager
@onready var economy_manager: EconomyManager = $EconomyManager

# Nodes
@onready var gold_label: Label = $HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Control/HBoxContainer/GoldLabel
@onready var upgrades_container: VBoxContainer = $HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Upgrades/UpgradesContainer
@export var button_scene: PackedScene
@onready var farmers_container: VBoxContainer = $HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Farmers/ScrollContainer/FarmersContainer
@onready var tree_remaining_label: Label = $HBoxContainer/LeftPanel/MarginContainer/Stats/TextureRect/TreeRemainingLabel

var player_damage: float = 1

# --- handle farmers 
var amount_farm_multiplier: float = 1



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

	
