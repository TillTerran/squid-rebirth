extends Node


var list_things_to_save=[]

func save_game():
	var file = FileAccess.open("savegame.data",FileAccess.WRITE)
	



func load_game():
	var file = FileAccess.open("savegame.data",FileAccess.READ)
	for save_object in list_things_to_save:
		save_object=file.get_var()
