extends StaticBody2D

@onready var c_m_plateform = $"C_m_plateform"
@onready var s_m_plateform = $"C_m_plateform/S_m_plateform"
#@export var max_angle=

@export var starts_active = true
@export var beltspeed = 1.5
@export var c_belt = false
@export var t_cycle=8.0
@export var max_angle=0.25

@export var length=100

@export var theta = 0.0 #phi initial tq pos=sin(cos(phi))

var is_active = true

#var speed = Vector2(hspeed,vspeed)
var origin = Vector2(200,100)
var center_of_movement=Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	theta = theta*PI
	max_angle=max_angle*PI
	is_active = starts_active
	center_of_movement=position
	s_m_plateform.polygon = c_m_plateform.polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_active:
		conveyor_belt()
#		position+=speed*delta
		accel(delta)
		if position.x>2000:
			position.x = 125
	


func accel(delta):
	# redo, doesn't work properly for circles, and doesn't work properly in most cases actually.
	#theta+=delta
	theta+=delta*2*PI/t_cycle
	theta= fmod(theta,2*PI)
	position = center_of_movement - Vector2(1,0)*length*sin(max_angle*cos(theta)) +Vector2(0,1)*length*cos(max_angle*cos(theta))
#	speed -= Vector2(1,0)*delta*max_hspeed*sin(-theta) +Vector2(0,1)*delta*max_vspeed*cos(theta)
#	if speed.x <-19:
#		print(position)


func conveyor_belt():
	if c_belt:
		constant_angular_velocity=beltspeed
