extends Node2D

@onready var player = $player
@export var tp_points_array:Array


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.main_menu.connect(to_main_menu)
	Events.change_scene.connect(change_scene)
	get_tree().paused=false
	var tp_points = get_tree().get_nodes_in_group("tp_points")
	for tp_point in tp_points:
		if tp_point.is_searched_tp_point(Events.tp_point_id):
			player.position=tp_point.position
	#player.position = tp_points[Events.tp_point_id].position
	Events.tp_point_id=0#value of the tp point where you respawn if you load from the main menu.
	pass # Replace with function body.





func change_scene(new_scene:String) -> void:
	"""changes the current scene to the new_scene, supports both packed and string paths, 
	will probably need  some work to have a propper loading screen"""
	
	if new_scene is String:
		get_tree().paused=true
		await $LevelTransition.fade_to_black()
		
		get_tree().change_scene_to_file(new_scene)
		
	#elif new_scene is PackedScene:
		#await $LevelTransition.fade_to_black()
		#await get_tree().change_scene_to_packed(new_scene)
	else:
		return
	#$LevelTransition.fade_from_black()

func to_main_menu():
	await change_scene(GlobalVariables.main_menu)


func _on_revealing_hidden_layer_area_body_entered(body: Node2D) -> void:
	print("aaaaaaaaaaaaaahhhh")
	$AnimationPlayer.play("illusion_fading")
	
