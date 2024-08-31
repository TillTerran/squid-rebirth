extends Area2D
var direction_proj=null
@export var speed = 150
func start(pos, direction):
	position = pos
	direction_proj=direction

func _process(delta):
	if direction_proj:
		position.x+=speed*delta
	else:
		position.x+=-speed*delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
