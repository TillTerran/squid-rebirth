extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.open_door.connect(open_door)
	pass # Replace with function body.


func open_door():
	queue_free()
