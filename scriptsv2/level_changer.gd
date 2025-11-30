extends Area2D

@export var connected_scene:String
@export var tp_point_id:int =0

func _on_body_entered(body):
	if body is CharacterBody2D:
		#print(get_tree().current_scene.scene_file_path)
		Events.tp_point_id=tp_point_id
		Events.change_scene.emit(connected_scene)
		
	
