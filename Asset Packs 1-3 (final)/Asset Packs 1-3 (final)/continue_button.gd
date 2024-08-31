extends Button


func _pressed()->void:
	startthegame()


func startthegame()->void:
	print("game_starts")
	Events.change_scene.emit(GlobalVariables.last_save_point)
