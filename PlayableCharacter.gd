class_name PlayableCharacter
extends CharacterBody2D

var coyote_jump:float=0

var jump_strength:float
var is_jumping:bool
@export var tile_size=16.0#size of a tile in pixel 
@export var height_of_jump:float=1.5 #height of the jump in tiles

func set_jump_height(new_height:float):
	height_of_jump=new_height
	jump_strength=sqrt(2.0*GlobalVariables.base_gravity_strength*(1+new_height*tile_size))# 16 pixel per tile; expected 

func jump_(delta:float,jump_desired:bool):
	if is_on_floor():
		if coyote_jump<0.2:
			
			coyote_jump = 0.2
		
	
	if not is_on_floor():
		coyote_jump -= delta
	if jump_desired:
		if coyote_jump>0 and not is_jumping:
			coyote_jump=0
			is_jumping=true
			print(Time.get_ticks_msec())
			return jump_strength*up_direction 
	else:
		is_jumping=false
		if velocity.dot(up_direction)>0.1:
			return -8*velocity.project(get_gravity())*delta
	
	return Vector2.ZERO
