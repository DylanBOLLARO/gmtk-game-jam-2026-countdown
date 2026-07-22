extends Control

const save_path = "user://userdata.save"

@onready var money_per_sec_label: Label = $LeftPanel/MarginContainer/Stats/HBoxContainer/MoneyPerSecLabel

var money: float = 0
var amount_per_click: int = 1

var elapsed := 0.0
var gold_gained := 0
var gold_per_second := 0.0

signal money_changed

func _ready() -> void:
	load_data()
	emit_signal("money_changed", money)


func add_gold(amount: int):
	money += amount
	gold_gained += amount
	emit_signal("money_changed", money)

func _process(delta):
	elapsed += delta

	if elapsed >= 1.0:
		gold_per_second = gold_gained / elapsed
		money_per_sec_label.text = "Gold/s: " + str(int(gold_per_second))
		gold_gained = 0
		elapsed = 0.0


func _on_timer_timeout():
	money += gold_per_second
	emit_signal("money_changed", money)
	print("Gold:", money)


func _on_texture_button_button_down() -> void:
	add_gold(amount_per_click)
	save_data()


func save_data():
	var data = {
		"money": money
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()


func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()
		file.close()

		if typeof(data) == TYPE_DICTIONARY:
			money = data.get("money", 0)
	else:
		save_data()
