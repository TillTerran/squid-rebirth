extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVariables.hp_pickup_taken:
		queue_free()
	pass # Replace with function body.




func _on_body_entered(body: Node2D) -> void:
	body.max_hp+=1
	body.current_hp=body.max_hp
	GlobalVariables.current_hp=body.max_hp
	GlobalVariables.max_hp+=1
	GlobalVariables.hp_pickup_taken=true
	queue_free()
