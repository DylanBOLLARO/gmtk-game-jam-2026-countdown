extends Control

@onready var hover_sound: AudioStreamPlayer = $HoverSound

func _ready() -> void:
	pass # Replace with function body.

func _on_play_button_down() -> void:
	TransitionScene.transition()
	await TransitionScene.on_transition_finishd
	get_tree().change_scene_to_file("res://Scene/game.tscn")

func _on_credits_button_down() -> void:
	pass # Replace with function body.

func _on_exit_button_down() -> void:
	TransitionScene.transition()
	await TransitionScene.on_transition_finishd
	get_tree().quit()

func _on_play_mouse_entered() -> void:
	hover_sound.play()

func _on_credits_mouse_entered() -> void:
	hover_sound.play()

func _on_exit_mouse_entered() -> void:
	hover_sound.play()
