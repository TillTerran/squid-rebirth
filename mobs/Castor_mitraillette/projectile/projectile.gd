extends CharacterBody2D

var target_position=Vector2(500,250)
var init_distance=null
var speed=150
# Called when the node enters the scene tree for the first time.
func ready(player_position):
	global_position=Vector2(250,250)
	init_distance=(player_position.x+self.global_position.x)/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction=(target_position-self.global_position).normalized()
	velocity.x=direction.x*speed
	if global_position.x>init_distance.x:
		velocity.y=30
		velocity=velocity.lerp(speed*direction,7*delta)
	else:
		velocity.y=-30
		velocity=velocity.lerp(speed*direction,7*delta)
	move_and_slide()
