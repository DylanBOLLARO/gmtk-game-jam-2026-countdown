extends Node
class_name SaveManager

const save_path = "user://userdata.save"


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
