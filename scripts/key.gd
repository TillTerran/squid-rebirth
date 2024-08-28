extends Node2D

@export var key_number:int=-1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if key_number !=-1:
		if GlobalVariables.taken_keys[key_number]:
			queue_free()
	else:
		queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.held_keys+=1
	GlobalVariables.held_keys+=1
	print(body.held_keys)
	if key_number !=-1:
		GlobalVariables.taken_keys[key_number]=true
	queue_free()
