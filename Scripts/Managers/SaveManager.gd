extends Node
class_name SaveManager

const save_path = "user://userdata.save"

func get_tree_manager() -> TreeManager:
	return get_tree().current_scene.get_node_or_null("TreeManager")
	
var intro_start_has_been_watched

func save_data():
	var data = {
		"intro_start_has_been_watched": intro_start_has_been_watched
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
			#intro_start_has_been_watched = data.get("intro_start_has_been_watched", false)
	#else:
	save_data()

	
func  reset_save() -> void:
	var data = {
		"intro_start_has_been_watched": false
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()
