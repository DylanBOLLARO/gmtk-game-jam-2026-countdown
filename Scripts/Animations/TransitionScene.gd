extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal on_transition_finishd

func  _ready() -> void:
	color_rect.visible = false
	animation_player.animation_finished.connect(on_animation_finished)
	
func on_animation_finished(anim_name):
	if anim_name == "FadeToBlack":
		on_transition_finishd.emit()
		animation_player.play("FadeToNormal")
	elif anim_name == "FadeToNormal":
		color_rect.visible = false
		
func  transition():
	color_rect.visible = true
	animation_player.play("FadeToBlack")
