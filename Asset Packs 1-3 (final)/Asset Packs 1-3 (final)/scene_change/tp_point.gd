extends Node2D

@export var tp_id=-1#-1 is the base
# Called when the node enters the scene tree for the first time.
func is_searched_tp_point(searched_tp_id) -> bool:
	if tp_id == searched_tp_id:
		return true
	return false


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.respawn_point = self.position


func _on_area_2d_body_exited(body: Node2D) -> void:
	body.respawn_point = self.position
