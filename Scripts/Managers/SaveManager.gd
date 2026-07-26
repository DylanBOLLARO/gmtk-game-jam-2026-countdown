extends Node
class_name SaveManager

const save_path = "user://userdata.save"

@onready var tree_manager: TreeManager = get_tree().current_scene.get_node("TreeManager")

var intro_start_has_been_watched

func save_data():
	var data = {
		#"total_trees_cut_down": tree_manager.total_trees_cut_down,
		#"total_trees_on_earth": tree_manager.total_trees_on_earth,
		"intro_start_has_been_watched.": false
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
			intro_start_has_been_watched = data.get("intro_start_has_been_watched", false)
			#tree_manager.total_trees_on_earth = data.get("total_trees_on_earth", 3_040_000_000_000)
	else:
		save_data()

func  _ready() -> void:
	load_data()
