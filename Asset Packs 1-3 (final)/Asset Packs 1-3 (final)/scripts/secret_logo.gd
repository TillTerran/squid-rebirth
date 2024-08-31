extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed_scale = 70

var number_of_slides=0



#onready var collision_polygon_2d = $"../terrain de test/CollisionPolygon2D"


var left_dir = Vector2(0,0)

var centered_gravity=false
var test_mode = true

@onready var animated_sprite = $AnimatedSprite2D




# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(1,1)
	up_direction = Vector2(0,-1)
	left_dir = up_direction.orthogonal()
	velocity=speed_scale*velocity.normalized()
	if test_mode:
		speed_scale=5
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	logo_mvt(delta)
	
	pass

func logo_mvt(delta):
	set_velocity(velocity)
	set_up_direction(up_direction)
	move_and_slide()
	velocity=2*velocity-velocity
	var n_slides = get_slide_collision_count()-1
	for i in range(n_slides):
		animated_sprite.set_frame((1+animated_sprite.get_frame())% 7)
	"""
	
	number_of_slides+=n_slides
	print(number_of_slides)
	print(n_slides)
	#if n_slides>=2:
	#	print(number_of_slides)
	#	print(n_slides)
	"""




































