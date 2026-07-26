extends Control

@onready var save_manager: SaveManager = get_tree().current_scene.get_node("SaveManager")
@onready var hover_sound: AudioStreamPlayer = $HoverSound

func _on_play_button_down() -> void:
	if save_manager.intro_start_has_been_watched:
		Utils.open_scene(GameEnum.Scene.GAME)
	else:
		save_manager.intro_start_has_been_watched = true
		save_manager.save_data()
		Utils.open_scene(GameEnum.Scene.INTRO_START)

func _on_credits_button_down() -> void:
	Utils.open_scene(GameEnum.Scene.CREDIT)

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

func  _ready() -> void:
	save_manager.load_data()
