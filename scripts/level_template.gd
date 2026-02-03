extends Node2D

@onready var player = %player
@export var tp_points_array:Array
var in_secret_zone=false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.change_scene.connect(change_scene)
	get_tree().paused=false
	var tp_points = get_tree().get_nodes_in_group("tp_points")
	for tp_point in tp_points:
		if tp_point.is_searched_tp_point(Events.tp_point_id):
			player.position=tp_point.position
	#player.position = tp_points[Events.tp_point_id].position
	Events.tp_point_id=0#value of the tp point where you respawn if you load from the main menu.
	
	for revealing_area in find_children("IllusionDispellerArea*"):
		revealing_area.body_entered.connect(_on_revealing_hidden_layer_area_body_entered)
		revealing_area.body_exited.connect(_on_revealing_hidden_layer_area_body_exited)
		print("area_found")
		
		
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

#func to_main_menu():
	#await change_scene(GlobalVariables.main_menu)


func _on_revealing_hidden_layer_area_body_entered(_body: Node2D) -> void:
	var state_machine = $AnimationTreeHiddenLayers.get("parameters/playback")
	state_machine.travel("illusion_fading")
	print("fade")


func _on_revealing_hidden_layer_area_body_exited(_body: Node2D) -> void:
	var state_machine = $AnimationTreeHiddenLayers.get("parameters/playback")
	state_machine.travel("illusion_coming_back")
	print("come back")
	
