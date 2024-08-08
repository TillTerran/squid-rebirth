extends RigidBody2D

func _ready():
	set_linear_velocity(Vector2(500,0))

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
