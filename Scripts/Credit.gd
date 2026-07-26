extends Control

func _on_credits_button_down() -> void:
	TransitionScene.transition()
	await TransitionScene.on_transition_finishd
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")
