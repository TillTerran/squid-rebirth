extends Node2D

@export var tp_id=-1#-1 is the base
# Called when the node enters the scene tree for the first time.
func is_tp_point(searched_tp_id):
	if tp_id == searched_tp_id:
		return self.position


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.respawn_point = self.position


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.respawn_point = self.position
