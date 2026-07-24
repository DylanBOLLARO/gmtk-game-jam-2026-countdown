extends Control

@onready var money_per_sec_label: Label = $HBoxContainer/LeftPanel/MarginContainer/Stats/HBoxContainer/MoneyPerSecLabel
@onready var gold_label: Label = $HBoxContainer/LeftPanel/MarginContainer/Stats/HBoxContainer/GoldLabel
@onready var farmers_container: VBoxContainer = $HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Farmers/FarmersContainer
@onready var upgrades_container: VBoxContainer = $HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Upgrades/UpgradesContainer
@export var button_scene: PackedScene

# variables
# --- handle click 

var player_stats: PlayerStats = PlayerStats.new()

# --- handle farmers 
var amount_farm_multiplier: float = 1

var timer := Timer.new()
const save_path = "user://userdata.save"



var all_farmers = [
	preload("res://Data/Farmers/Minotaur.tres"),
	preload("res://Data/Farmers/Woodcutter.tres"),
]

var all_upgrades = [
	preload("res://Data/Upgrades/BetterAx.tres"),
	preload("res://Data/Upgrades/MinotaurBetterWeapon.tres"),
	preload("res://Data/Upgrades/WoodcutterBetterWeapon.tres"),
]


func load_resources(path: String) -> Array:
	var resources = []
	print("📁 Attempting to load from: ", path)
	
	var dir = DirAccess.open(path)
	if dir:
		print("✅ Directory opened successfully")
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var count = 0
		while file_name != "":
			print("  Found file: ", file_name)
			if file_name.ends_with(".tres"):
				var resource = load(path + "/" + file_name)
				print("    Loaded: ", resource)
				resources.append(resource)
				count += 1
			file_name = dir.get_next()
		dir.list_dir_end()
		print("✅ Loaded ", count, " resources")
	else:
		print("❌ FAILED to open directory: ", path)
	
	return resources

func update_ui_gold():
	gold_label.text = str(EconomyManager.gold)

func generate_all_upgrades():
	#remove all items in list
	for child in upgrades_container.get_children():
		child.queue_free()
	
	var sorted = all_upgrades.duplicate()

	sorted.sort_custom(func(a, b):
		return a.cost < b.cost
	)
	
	# generate all items in list
	for item in sorted:
		var owned := false

		for upgrade in PurchaseManager.owned_upgrades:
			if upgrade["name"] == item.name:
				owned = true
				break

		if owned:
			continue

		var hbox = HBoxContainer.new()
		hbox.anchor_right = 1.0
		hbox.anchor_bottom = 1.0
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
		var button_instance = button_scene.instantiate()
		button_instance.setup(item)
		
		hbox.add_child(button_instance)
		
		upgrades_container.add_child(hbox)
		
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
			
		var button_instance = button_scene.instantiate()
		button_instance.setup(item)
		
		hbox.add_child(button_instance)
		hbox.add_child(count_label)
		
		farmers_container.add_child(hbox)

func _ready() -> void:
	print("🔍 EXPORT DEBUG - Windows")
	print("button_scene path: ", button_scene)
	print("button_scene exists: ", button_scene != null)
	print("button_scene instantiate works: ", button_scene.instantiate() != null if button_scene else "NULL")
	print("all_upgrades size: ", all_upgrades.size())
	print("all_farmers size: ", all_farmers.size())
	
	player_stats.click_amount = 50
	
	timer.wait_time = 1
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	
	load_data()
	
	EconomyManager.gold_changed.connect(update_ui_gold)
	EconomyManager.gold_changed.connect(generate_all_farmers)
	EconomyManager.gold_changed.connect(generate_all_upgrades)
	EconomyManager.emit_signal("gold_changed")

func _on_timer_timeout():
	EconomyManager.add_gold(EconomyManager.get_gold_per_second())
	money_per_sec_label.text = "Gold/s: " + str(round(EconomyManager.gold_gained_this_second))
	EconomyManager.gold_gained_this_second = 0

func get_click_value() -> float:
	var amount = player_stats.click_amount
	var multiplier = player_stats.click_multiplier
	
	for upgrade in PurchaseManager.owned_upgrades:
		if upgrade.stats is PlayerStats:
			amount += upgrade.stats.click_amount
			multiplier += upgrade.stats.click_multiplier
			
	return amount * multiplier
	
func _on_texture_button_button_down() -> void:
	EconomyManager.add_gold(get_click_value())
	save_data()

func save_data():
	var data = {
		"gold": EconomyManager.gold
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_data():
	#if FileAccess.file_exists(save_path):
		#var file = FileAccess.open(save_path, FileAccess.READ)
		#var data = file.get_var()
		#file.close()
#
		#if typeof(data) == TYPE_DICTIONARY:
			#EconomyManager.gold = data.get("gold", 0)
	#else:
	save_data()
