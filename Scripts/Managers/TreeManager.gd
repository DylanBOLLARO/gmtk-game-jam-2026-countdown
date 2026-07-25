extends Node
class_name TreeManager

@onready var ui_manager: UIManager = get_tree().current_scene.get_node("UIManager")
@onready var economy_manager: EconomyManager = get_tree().current_scene.get_node("EconomyManager")

@onready var texture_button: TextureButton = $"../HBoxContainer/LeftPanel/MarginContainer/CenterContainer/TextureButton"

var total_trees_on_earth: int = 3_040_000_000_000
var total_trees_cut_down: int = 0
var current_path = null
var current_tree_hp: float = 0
var current_tree_max_hp: float = 0

var all_trees_sprites = [
	"res://Assets/Trees/Snow_tree1.png",
	"res://Assets/Trees/Palm_tree2_1.png",
	"res://Assets/Trees/Palm_tree1_1.png",
	"res://Assets/Trees/Moss_tree1.png",
	"res://Assets/Trees/Fruit_tree1.png",
	"res://Assets/Trees/Flower_tree1.png",
	"res://Assets/Trees/Christmas_tree1.png",
	"res://Assets/Trees/Autumn_tree1.png",
	"res://Assets/Trees/Burned_tree1.png",
]
	
func get_random_tree_sprite():
	var local_copy = all_trees_sprites.duplicate()
	local_copy.remove_at(local_copy.find(current_path))
	return local_copy[randi_range(0, local_copy.size() - 1)]
	
func generate_new_tree_sprite():
	var path = get_random_tree_sprite()
	current_path = path
	texture_button.texture_normal = load(path)
	
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
		
func hit_tree(amount:float = 1.0):
	current_tree_hp -= amount
	
	if current_tree_hp <= 0:
		total_trees_cut_down += 1
		generate_new_tree()
		ui_manager.update_ui_tree_remaining()
		economy_manager.add_gold(1)
		
	ui_manager.update_ui_current_tree_hp()
