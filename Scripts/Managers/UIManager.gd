extends Node
class_name UIManager

# signals
signal on_player_click_on_tree

# Managers
@onready var economy_manager: EconomyManager = get_tree().current_scene.get_node("EconomyManager")
@onready var tree_manager: TreeManager = get_tree().current_scene.get_node("TreeManager")

@onready var gold_label: Label = $"../HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/GoldLabel"
@onready var money_per_sec_label: Label = $"../HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/MoneyPerSecLabel"
@onready var texture_button: TextureButton = $"../HBoxContainer/LeftPanel/MarginContainer/CenterContainer/TextureButton"
@onready var tree_remaining_label: Label = $"../HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/TreeRemainingLabel"
@onready var current_tree_hp: Label = $"../HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/CurrentTreeHP"
@onready var current_tree_hp_bar: ProgressBar = $"../HBoxContainer/LeftPanel/MarginContainer/Panel/Stats/CurrentTreeHPBar"
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func init_ui():
	update_ui_player_gold()
	update_ui_tree_remaining()
	update_ui_current_tree_hp()
	
func _ready() -> void:
	economy_manager.on_gold_changed.connect(update_ui_player_gold)
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
	
func  update_ui_tree_remaining():
	tree_remaining_label.text = format_with_spaces(tree_manager.total_trees_on_earth-tree_manager.total_trees_cut_down)

func  update_ui_current_tree_hp():
	current_tree_hp_bar.max_value = tree_manager.current_tree_max_hp
	current_tree_hp_bar.value = tree_manager.current_tree_hp
