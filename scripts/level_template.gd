extends Node2D

@onready var player = $player


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.main_menu.connect(to_main_menu)
	Events.change_scene.connect(change_scene)
	pass # Replace with function body.





func change_scene(new_scene) -> void:
	"""changes the current scene to the new_scene, supports both packed and string paths, 
	will probably need  some work to have a propper loading screen"""
	if new_scene is String:
		await $LevelTransition.fade_to_black()
		get_tree().change_scene_to_file(new_scene)
	#elif new_scene is PackedScene:
		#await $LevelTransition.fade_to_black()
		#await get_tree().change_scene_to_packed(new_scene)
	else:
		return
	$LevelTransition.fade_from_black()

func to_main_menu():
	await change_scene("res://levels/main_menu_good.tscn")



