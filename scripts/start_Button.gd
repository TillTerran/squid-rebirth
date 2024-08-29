extends Button



func _pressed():
	startthegame()


func startthegame():
	print("game_starts")
	Events.change_scene.emit(GlobalVariables.last_save_point)
