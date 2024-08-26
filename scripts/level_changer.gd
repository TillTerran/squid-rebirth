extends Area2D

@export var connected_scene:String

func _on_body_entered(body):
	if body is CharacterBody2D:
		#print(get_tree().current_scene.scene_file_path)
		Events.change_scene.emit(connected_scene)
	
