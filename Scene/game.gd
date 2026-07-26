extends Control
@onready var bg_music_sound: AudioStreamPlayer = $BGMusicSound

func _ready() -> void:
	bg_music_sound.finished.connect(_on_bg_music_finished)

func _on_bg_music_finished() -> void:
	bg_music_sound.play()
	
