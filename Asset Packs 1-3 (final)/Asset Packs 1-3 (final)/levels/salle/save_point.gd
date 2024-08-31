extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_save_point_body_entered(body: Node2D) -> void:
	if body.has_method(&"save"):
		body.save()


func _on_save_point_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
