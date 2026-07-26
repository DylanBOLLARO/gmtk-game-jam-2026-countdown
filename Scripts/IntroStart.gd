extends Control
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Panel/MarginContainer/Label
var pages = []
@onready var texture_button: TextureButton = $TextureButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_voices_player: AudioStreamPlayer = $AudioVoicesPlayer

signal _page_advance

var _last_sound_path := {}

func play_sound(player: AudioStreamPlayer, path) -> void:
	if path == null or path == "":
		return
	if _last_sound_path.get(player) == path and player.playing:
		return
	var stream = load(path)
	if stream == null:
		return
	_last_sound_path[player] = path
	player.stream = stream
	player.play()
	
func play_page(config) -> void:
	if config.get("index") != 0:
		TransitionScene.transition()
		await TransitionScene.on_transition_finishd

	play_sound(audio_stream_player, config.get("sound"))
	play_sound(audio_voices_player, config.get("sound_voices"))
	
	texture_rect.texture = load(config.get("background_image"))
	label.text = config.get("label")
 
	var timer := get_tree().create_timer(config.get("duration"))
 
	var on_timeout := func():
		_page_advance.emit()
	var on_skip := func():
		_page_advance.emit()
 
	timer.timeout.connect(on_timeout, CONNECT_ONE_SHOT)
	texture_button.button_down.connect(on_skip, CONNECT_ONE_SHOT)
 
	await _page_advance
 
	if timer.timeout.is_connected(on_timeout):
		timer.timeout.disconnect(on_timeout)
	if texture_button.button_down.is_connected(on_skip):
		texture_button.button_down.disconnect(on_skip)


func _ready() -> void:
	audio_stream_player.volume_linear = 0.25
	audio_voices_player.volume_linear = 5
	
	pages.append({
		"index": 0,
		"duration": 18,
		"label": "Narrator – Welcome, my little Dwarf!\n\nI’m going to tell you a wonderful story!\nIn a world full of magic and wonderful people like humans, Orcs, Tauren, Trolls, and most of all, elves!\n\nDwarf – Elves?!",
		"background_image": "res://Assets/Images/IntroStartBG.png",
		"sound":"res://Assets/Sounds/lightyeartraxx-kl-peach-game-over-ii-135684.mp3",
		"sound_voices":"res://Assets/Sounds/voices/sound_voices_intro_page_1.wav"
	})
	pages.append({
		"index": 1,
		"duration": 23,
		"label": "Narrator – (chuckles) Nooo, just kidding! We’ve never been able to stand those guys!
			Especially lately, ever since those idiots had the brilliant idea to suck on a stick that gave them a virus!\nSince then, almost all of them have gotten even crazier, with really gray skin!\n\nDwarf – Is that even possible?!",
		"background_image": "res://Assets/Images/IntroEndBG.png",
		"sound":"res://Assets/Sounds/lightyeartraxx-kim-lightyear-angel-eyes-chiptune-edit-110226.mp3",
		"sound_voices":"res://Assets/Sounds/voices/sound_voices_intro_page_2.wav"
	})
	pages.append({
		"index": 2,
		"duration": 10,
		"label": "Narrator – Possible? Even Gurdil would’ve bet two barrels of beer that it was impossible to get any dumber!\nThose idiots think the trees are talking and telling them to invade us!\nAt first, we had a good laugh with the guys, but then they started coming to our place and growing trees in our mining sites!!\n\nDwarf – But how are we going to stop them?!\nNarrator – With our axes, of course!!\n\nCome on over, because today is dandelion-eater recycling day and a big deforestation operation!",
		"background_image": "res://Assets/Images/IntroEndBG.png",
		"sound":"res://Assets/Sounds/lightyeartraxx-kim-lightyear-angel-eyes-chiptune-edit-110226.mp3",
		"sound_voices":"res://Assets/Sounds/voices/sound_voices_intro_page_3.wav"
	})

	for i in range(pages.size()):
		await play_page(pages[i])
		
	Utils.open_scene(GameEnum.Scene.GAME)


func _on_texture_button_button_down() -> void:
	_page_advance.emit()
