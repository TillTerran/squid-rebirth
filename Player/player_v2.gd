extends CharacterBody2D

@onready var world = $".."
@onready var player_sprite = $player_sprite

@export var level:PackedScene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed_scale = 1.5

#var velocity = Vector2.ZERO


var floating=0 #is not affected by gravity ?

var mass = 1

var jump= 300

var coyote_jump = 0

var frixion = 750

var gravity=-500 #gravity strength

var p_walkaccel = 500 

var max_velocity = 2000

#onready var collision_polygon_2d = $"../terrain de test/CollisionPolygon2D"

#var up_direction = Vector2(0,-1)
var left_dir = up_direction.orthogonal()
var abs_rotation = 0

var centered_gravity=false

var impacts = []

var accel = []
#check here to test things
var impactsv1 = false
var test_mode = false
var fun_mode = false
var bouncing= false
var bouncyness=0.75





# Called when the node enters the scene tree for the first time.
func _ready():
	centered_gravity=false
	
	if fun_mode:
		frixion=0
		speed_scale=2
		bouncing = true
		
	if test_mode:
		#centered_gravity=true
		frixion = 250
	#rotate(up_direction.angle_to(Vector2(0,-1)))
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#if area_entered onready var terrain_de_test = $"../terrain de test"
	if Input.is_action_just_pressed("ui_select"):
		change_gravity_type(not centered_gravity)
		print("space")
	
	if Input.is_action_just_pressed("ui_cancel"):
		Events.main_menu.emit()
	
	update_up_direction()
	
	
	if Input.is_action_pressed("ui_a"):
		print(rotation_degrees)
	
	p_mvt(delta)

func p_mvt(delta):
	
	var vec_gravity = up_direction*gravity
	
	if test_mode:
		if impactsv1:
			receive_impactv1(left_dir)
		else:
			receive_impactv2(left_dir)
		for n in range(len(impacts)):
			accel.append(impacts[n]) 
	
	
	impacts = []
	var input_vector = Vector2.ZERO
	var bounced_vec=Vector2.ZERO
	var floor_normal = 0
	input_vector = left_dir* p_walkaccel * (Input.get_axis("ui_right","ui_left"))
	accel.append(vec_gravity*delta)
	
	
	update_animation(input_vector)
	#print(input_vector)
	
	
	accel.append(input_vector*delta)
	accel.append(jump_(delta))
	velocity=apply_accel(delta,accel,velocity)
	accel = []
	"""if input_vector.x==0:
		input_vector.x = move_toward(input_vector.x,0,frixion)
	"""
	
	process_movement()
	
	
	
	#if position.y < 0:
	#	position.y = 0
	#	velocity.y = 0
	#if position.y > 360:
	#	position.y = 360
	#	velocity.y = 0
	
		






func jump_(delta):
	if is_on_floor():
		coyote_jump = 0.3
		
	
	
	if not is_on_floor():
		coyote_jump -= delta
	if Input.is_action_pressed("ui_up"):
		if coyote_jump>0:
			coyote_jump=0
			print(up_direction)
			return jump*up_direction 
	else:
		pass
			
	return Vector2.ZERO
	
func process_movement():
	if bouncing:
		set_velocity(velocity)
		set_up_direction(up_direction)
		move_and_slide()
		velocity = (1+bouncyness)*velocity-velocity*bouncyness
	else:
		set_velocity(velocity)
		set_up_direction(up_direction)
		move_and_slide()
		#velocity = velocity
	
	

func receive_impactv1(impact_vec):
	"""à utiliser avec de l'invincibilité pour éviter une création trop grande de distance"""
	impacts.append(impact_vec)

func receive_impactv2(impact_vec):
	"""à utiliser avec de l'invincibilité pour éviter une création trop grande de distance"""
	impact_vec.x= sqrt(impact_vec.x**2+velocity.x**2-2*impact_vec.x*velocity.x)-velocity.x
	impact_vec.y= sqrt(impact_vec.y**2+velocity.y**2-2*impact_vec.y*velocity.y)-velocity.y
	impacts.append(impact_vec)


func add_force(force):
	
	accel.append(force/mass)

func change_gravity_type(is_centered):
	centered_gravity = is_centered
	#print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaah")
	change_up_direction(up_direction)


func update_animation(input_vector):
	if input_vector!=Vector2.ZERO:
		player_sprite.play("run")
		player_sprite.flip_h = (input_vector.dot(-left_dir)<0)
	else:
		player_sprite.play("idle")
	
	if not is_on_floor():
		player_sprite.play("jump")


func update_up_direction():
	
	#print(centered_gravity)
	
	if centered_gravity:
		var center=Vector2(world.gravity_center_position.x-position.x,world.gravity_center_position.y-position.y)
		#actually,center is currently the center of gravity of the room relative to the player's position.
		
		if not center == Vector2.ZERO:
			change_up_direction(center)
			
			
	else:
		if Input.is_action_just_pressed("ui_accept") and not Input.is_action_just_pressed("ui_select"):
			print('something')
			change_up_direction(up_direction.rotated(PI/8))
		pass


func change_up_direction(n_direction):
	var rotation_step = PI/8
	
	
	print('anything')
	
	if not centered_gravity:
		
		#n_direction = Vector2(-1,0).rotated(snapped(n_direction.angle_to(Vector2(1,0)),rotation_step))
		
		n_direction = Vector2(-1,0).rotated(-snapped(up_direction.angle_to(Vector2(-1,0)),rotation_step))
		
		
	abs_rotation += up_direction.angle_to(n_direction)
	up_direction = up_direction.rotated(up_direction.angle_to(n_direction))
	#up_direction =up_direction.rotated(stepify(up_direction.angle_to(n_direction),PI/32))
	
	#if not centered_gravity:
	#	up_direction=snapped(up_direction,PI/8)
		
	up_direction=up_direction.normalized()
	left_dir = up_direction.orthogonal()
	
	if centered_gravity:
		rotation = snapped(abs_rotation,PI/32)
	else:
		rotation = snapped(abs_rotation,rotation_step)
	
	
	
	pass



func apply_accel(delta,a_vectors,v_vector,max_Speed=800):
	var a_vector = Vector2.ZERO
	for i in range(len(a_vectors)):
		a_vector.x += a_vectors[i].x
		a_vector.y += a_vectors[i].y
	
	a_vector -= gravity*floating*up_direction #applying wether the player is bound to gravity or not ==> should be made into a vector in the list of vectors
	
	
	
	if round(a_vector.dot(left_dir))==0:
		#print("normal")
		if v_vector.dot(left_dir)==0:
			#print("argh")
			pass
		else:
			v_vector = v_vector.move_toward(up_direction*up_direction.dot(v_vector),12.5*frixion*delta*speed_scale)
			#print("bloups")
	#print(a_vector.dot(left_dir))
	a_vector.x*=speed_scale
	a_vector.y*=speed_scale
	v_vector += a_vector
	
	#v_vector.x
	
	
	#print(v_vector)
	return v_vector.limit_length(max_velocity)



"""
func apply_accel_SHMUP(delta,a_vectors,v_vector,max_Speed=200):
	var a_vector = Vector2.ZERO
	for i in range(len(a_vectors)):
		a_vector.x += a_vectors[i].x
		a_vector.y += a_vectors[i].y
	
	a_vector.y -= gravity*floating #applying wether the player is bound to gravity or not ==> should be made into a vector in the list of vectors
	
	
	if a_vector.dot(left_dir)==0:
		if centered_gravity:
				print(v_vector)
				v_vector = v_vector.move_toward(Vector2.ZERO,frixion)
				print(v_vector)
		else:
			if v_vector.dot(left_dir)==0:
				pass
			else:
				v_vector = v_vector.move_toward(up_direction*up_direction.dot(v_vector),frixion)
	
	#a_vector.x*=speed_scale
	#a_vector.y*=speed_scale
	v_vector += a_vector
	
	
	
	v_vector.limit_length(max_Speed)
	return v_vector

"""






'''
func _on_c_gravity_area_body_exited(body):
	change_gravity_type(false)
	print("aahh")
	print(up_direction.angle())




func _on_c_gravity_area_body_entered(body):
	"""note : this is launched once upon starting the game"""
	print(Time)
	change_gravity_type(true)
	print("ha")
	pass # Replace with function body.


'''


