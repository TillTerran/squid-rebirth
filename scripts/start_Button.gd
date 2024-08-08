extends Button



func _pressed():
	startthegame()


func startthegame():
	print("game_starts")
	Events.up_level.emit()
