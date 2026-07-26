extends Control
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Panel/MarginContainer/Label
var pages = []
@onready var texture_button: TextureButton = $TextureButton

	
	
func play_page(config):
	# when i click on texture_button i want to skip this page to go to next one
	
	if config.get("index") != 0:
		TransitionScene.transition()
		await TransitionScene.on_transition_finishd
		
	texture_rect.texture = load(config.get("background_image"))
	label.text = config.get("label")
	await get_tree().create_timer(config.get("duration")).timeout

func _ready() -> void:
	pages.append({
		"index": 0,
		"duration": 5,
		"label": "Narrator – Welcome, my little Dwarf!\n\nI’m going to tell you a wonderful story!\nIn a world full of magic and wonderful people like humans, Orcs, Tauren, Trolls, and most of all, elves!\n\nDwarf – Elves?!",
		"background_image": "res://Assets/Images/IntroStartBG.png"
	})
	pages.append({
		"index": 1,
		"duration": 8,
		"label": "Narrator – (chuckles) Nooo, just kidding! We’ve never been able to stand those guys!
			Especially lately, ever since those idiots had the brilliant idea to suck on a stick that gave them a virus!\nSince then, almost all of them have gotten even crazier, with really gray skin!\n\nDwarf – Is that even possible?!",
		"background_image": "res://Assets/Images/ForestB.png"
	})
	pages.append({
		"index": 2,
		"duration": 10,
		"label": "Narrator – Possible? Even Gurdil would’ve bet two barrels of beer that it was impossible to get any dumber!\nThose idiots think the trees are talking and telling them to invade us!\nAt first, we had a good laugh with the guys, but then they started coming to our place and growing trees in our mining sites!!\n\nDwarf – But how are we going to stop them?!\nNarrator – With our axes, of course!!\n\nCome on over, because today is dandelion-eater recycling day and a big deforestation operation!",
		"background_image": "res://Assets/Images/IntroEndBG.png"
	})

	for i in range(pages.size()):
		await play_page(pages[i])
		
	Utils.open_scene(GameEnum.Scene.GAME)


func _on_texture_button_button_down() -> void:
	pass # Replace with function body.
