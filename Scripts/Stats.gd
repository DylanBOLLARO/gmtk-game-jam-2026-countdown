extends VBoxContainer

@onready var money_label: Label = $HBoxContainer/MoneyLabel

func _on_game_money_changed(amount) -> void:
	money_label.text = "money : " + str(amount)
