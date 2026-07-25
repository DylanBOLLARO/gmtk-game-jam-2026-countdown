extends Node
class_name TreeManager

signal on_total_trees_cut_down_changed

@onready var ui_manager: UIManager = get_tree().current_scene.get_node("UIManager")

@onready var texture_button: TextureButton = $"../HBoxContainer/LeftPanel/MarginContainer/CenterContainer/TextureButton"

var total_trees_on_earth: int = 3_040_000_000_000
var total_trees_cut_down: int = 0

var current_tree_hp: float = 0
var current_tree_max_hp: float = 0

var all_trees_sprites = [
	load("res://Assets/Trees/Snow_tree1.png"),
	load("res://Assets/Trees/Palm_tree2_1.png"),
	load("res://Assets/Trees/Palm_tree1_1.png"),
	load("res://Assets/Trees/Moss_tree1.png"),
	load("res://Assets/Trees/Fruit_tree1.png"),
	load("res://Assets/Trees/Flower_tree1.png"),
	load("res://Assets/Trees/Christmas_tree1.png"),
	load("res://Assets/Trees/Autumn_tree1.png"),
	load("res://Assets/Trees/Burned_tree1.png"),
]
	
func get_random_tree_sprite():
	return all_trees_sprites[randi_range(0, all_trees_sprites.size() - 1)]
	
func generate_new_tree_sprite():
	texture_button.texture_normal = get_random_tree_sprite()
	
func generate_tree_stats():
	current_tree_max_hp = total_trees_on_earth - ( total_trees_on_earth - total_trees_cut_down ) + 1
	current_tree_hp = current_tree_max_hp
	
func  _ready() -> void:
	generate_new_tree_sprite()
	generate_tree_stats()
	ui_manager.on_player_click_on_tree.connect(hit_tree)

func generate_new_tree():
	generate_new_tree_sprite()
	generate_tree_stats()
		
func hit_tree():
	current_tree_hp -= 1
	
	if current_tree_hp <= 0:
		total_trees_cut_down += 1
		generate_new_tree()
		ui_manager.update_ui_tree_remaining()
		
	ui_manager.update_ui_current_tree_hp()
