extends Button

var first_level:String = "res://levels/salle/Salle 01.tscn"

func _ready():
	pass

func _pressed():
	startthegame()


func startthegame():
	print("game_starts")
	GlobalVariables._ready()
	Events.change_scene.emit(first_level)
