extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jump_P = 30
var speed = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func (form,last_storypoint):
#	"""form designates wether the player is the monkey or the ghost, and
#	last_storypoint is the number(?) designating the set of powers the character unlocked"""
#	if form == "monkey" :
#		var monkey=true


func movement(form,inputs):
	pass
	

func jump():
	"""jump_power should be adjusted to match the expected behaviour"""
	var jump_power=30
	if canJump():
		self.v_speed = jump_power#*jump_factors

func canJump():
	pass


















