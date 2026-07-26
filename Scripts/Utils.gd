extends Node

func open_scene(in_scene:GameEnum.Scene):
	var scene_to_load = null
	
	match in_scene:
		GameEnum.Scene.MAIN_MENU:
			scene_to_load = preload("res://Scene/MainMenu.tscn")
		GameEnum.Scene.GAME:
			scene_to_load = preload("res://Scene/Game.tscn")
		GameEnum.Scene.CREDIT:
			scene_to_load = preload("res://Scene/Credit.tscn")
		GameEnum.Scene.INTRO_START:
			scene_to_load = preload("res://Scene/IntroStart.tscn")
		GameEnum.Scene.INTRO_END:
			scene_to_load = preload("res://Scene/IntroEnd.tscn")
			
	if scene_to_load:
		TransitionScene.transition()
		await TransitionScene.on_transition_finishd
		get_tree().change_scene_to_packed(scene_to_load)
		
func format_with_spaces(number: int) -> String:
	var s = str(number)
	var result = ""
	var count = 0
	for i in range(s.length() - 1, -1, -1):
		result = s[i] + result
		count += 1
		if count % 3 == 0 and i != 0:
			result = " " + result
	return result
	
func format_compact_number(n: float) -> String:
	if abs(n) < 1000:
		return str(int(n)) if n == int(n) else str(n)
	
	var units = [
		["Q", 1_000_000_000_000_000.0],  # Quadrillion
		["T", 1_000_000_000_000.0],      # Trillion
		["B", 1_000_000_000.0],          # Billion
		["M", 1_000_000.0],              # Million
		["K", 1000.0]                    # Thousand
	]
	
	for unit_data in units:
		var suffix: String = unit_data[0]
		var divisor: float = unit_data[1]
		if abs(n) >= divisor:
			var value = n / divisor
			var formatted = "%.1f" % value
			# Strip trailing .0
			if formatted.ends_with(".0"):
				formatted = formatted.substr(0, formatted.length() - 2)
			return formatted + suffix
	
	return str(n)
