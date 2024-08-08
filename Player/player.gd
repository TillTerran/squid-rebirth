extends CharacterBody2D

@onready var world = $".."
@onready var player_sprite = $player_sprite

@export var level:PackedScene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed_scale = 1.5

#var velocity = Vector2.ZERO

var animation_prefix=""
var floating=false #is not affected by gravity ?

var height_of_jump=1#height of the jump in tiles

var mass = 1

var coyote_jump = 0

var frixion = 750

var gravity=-500  #gravity strength

@export var jump= -gravity*height_of_jump/4 #non linear between jump = 200 and jump = 300, have to fix that

var p_walkaccel = 500 

var max_velocity = 2000

#onready var collision_polygon_2d = $"../terrain de test/CollisionPolygon2D"

#var up_direction = Vector2(0,-1)
var left_dir = up_direction.orthogonal()
var input_left_dir=1 #changer le nom de la variable
var just_stopped=false


var abs_rotation = 0

var centered_gravity=false

var impacts = []

var accel = Vector2.ZERO
#check here to test things
var impactsv1 = false
var test_mode = false
var fun_mode = false
var bouncing= false
var bouncyness=0.75
var gravity_point=null
var gravity_vect = -up_direction


var is_punching = false

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
	
	animation_prefix=get_animation_prefix()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):# try to change to _physics_process
	
	#if area_entered onready var terrain_de_test = $"../terrain de test"
#	if Input.is_action_just_pressed("ui_select"): # obsolete... for now
#		change_gravity_type(not centered_gravity)
#		print("space")
	
	centered_gravity = (gravity_point != null)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Events.main_menu.emit()
	
	
	
	
	
	if not floating:
		update_up_direction()
	
	
	if Input.is_action_pressed("ui_a"):
		print(rotation_degrees)
	
	p_mvt(delta)



#func _physics_process(delta):
#	
#
#
#	pass












func p_mvt(delta):
	
	var vec_gravity = up_direction*gravity
	
	
	test_impacts()
	
	
	
	#impacts = []
	var input_vector = Vector2.ZERO
	#var bounced_vec=Vector2.ZERO
	#var floor_normal = 0
	
	
	input_vector = get_inputs(delta,input_vector,vec_gravity)
	update_animation(input_vector)
	
	
	#print(input_vector)
	
	
	
	
	velocity=apply_accel(delta,accel,velocity)
	accel = Vector2.ZERO
	"""if input_vector.x==0:
		input_vector.x = move_toward(input_vector.x,0,frixion)
	"""
	
	process_movement()
	

func get_inputs(delta,input_vector,vec_gravity):
	"""registers the input vectors and adds tehir corresponding accel_vectors to accel"""
	if floating:#changes the movement from plateformer to top-down, ask Phantom for details if needed
		input_vector = left_dir * (Input.get_axis("ui_right","ui_left"))
		input_vector += up_direction  * (Input.get_axis("ui_down","ui_up"))
		accel+=input_vector*p_walkaccel*delta
		
	else:
		input_vector = left_dir * (Input.get_axis("ui_right","ui_left"))
		change_left_perception(input_vector)
		
		accel+=vec_gravity*delta
		accel+=jump_(delta)
		accel+=input_vector*input_left_dir*p_walkaccel*delta
	
	return input_vector



func test_impacts():
	"""function to test how I should add impacts to the player(like a blunt attack)"""
	if test_mode:
		if impactsv1:
			receive_impactv1(left_dir)
		else:
			receive_impactv2(left_dir)
		for n in range(len(impacts)):
			accel+=impacts[n]



func jump_(delta):
	if is_on_floor():
		coyote_jump = 0.2
		
	
	
	if not is_on_floor():
		coyote_jump -= delta
	if Input.is_action_pressed("ui_up"):
		if coyote_jump>0:
			coyote_jump=0
			#print(up_direction)
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
	
	accel+=force/mass

#func change_gravity_type(is_centered):
#	centered_gravity = is_centered
#	#print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaah")
#	change_up_direction(up_direction)


func update_animation(input_vector):
	
	
	if Input.is_action_just_pressed("ui_right") :
		if $punchhitbox.position.x < 0 :
			$punchhitbox.position.x = $punchhitbox.position.x * -1
		$SpriteTree/Run.flip_h = false
		$SpriteTree/Idle.flip_h = false
		$SpriteTree/Punch.flip_h = false
	if Input.is_action_just_pressed("ui_left") :
		if $punchhitbox.position.x > 0 :
			$punchhitbox.position.x = $punchhitbox.position.x * -1
		$SpriteTree/Run.flip_h = true
		$SpriteTree/Idle.flip_h = true
		$SpriteTree/Punch.flip_h = true

	if input_vector!=Vector2.ZERO and $AnimationPlayer.current_animation != "PL_player_punch":
		"Deux ligne suivant forcée due au faite ques les sprites sont séparé en plusieurs fichiers"
		$SpriteTree/Idle.visible = false 
		$SpriteTree/Run.visible = true 
		$SpriteTree/Punch.visible = false
		"$SpriteTree/Run.flip_h = (input_vector.dot(-left_dir)<0)"
		$AnimationPlayer.play("PL_player_run")
	else:
		if $AnimationPlayer.current_animation != "PL_player_punch":
			"Deux ligne suivant forcée due au faite ques les sprites sont séparé en plusieurs fichiers"
			$SpriteTree/Idle.visible = true 
			$SpriteTree/Run.visible = false 
			$SpriteTree/Punch.visible = false
			"$SpriteTree/Run.flip_h = (input_vector.dot(-left_dir)<0)"
			$AnimationPlayer.play("PL_player_idle")
	if Input.is_action_just_pressed("Punch") and $PunchCooldown.is_stopped():
		print("Punch action")
		$SpriteTree/Idle.visible = false 
		$SpriteTree/Run.visible = false 
		$SpriteTree/Punch.visible = true
		$AnimationPlayer.play("PL_player_punch")
		$PunchCooldown.start()
	"""
	
	if not is_on_floor():
		player_sprite.play("jump")"""
	"""$SpriteTree.flip_h = (input_vector.dot(-left_dir)<0)"""
	

func change_left_perception(input_vector):
	"""makes the right/left direction correspond to what's displayed on the screen
	(character upside-down => left input makes the character go left even though the actual left of the character is 
	not the same)"""
	if input_vector!=Vector2.ZERO:
		just_stopped =true
		
	elif just_stopped:
		just_stopped=false
		input_left_dir=sign(left_dir.dot(Vector2(-1,0)))
		if input_left_dir==0:
			input_left_dir=sign(left_dir.dot(Vector2(0,1)))




func update_up_direction():
	
	if centered_gravity:
		change_up_direction(gravity_point-position)
	elif gravity_vect!=Vector2.ZERO:
		change_up_direction(gravity_vect)
	#else : don't change the up_direction
	


func change_up_direction(n_direction):
	
	var rotation_step = PI/4#formerly PI/8
	
	
	
	if not centered_gravity:
		
		#n_direction = Vector2(-1,0).rotated(snapped(n_direction.angle_to(Vector2(1,0)),rotation_step))
		
		n_direction = Vector2(-1,0).rotated(-snapped(up_direction.angle_to(Vector2(-1,0)),rotation_step))
		
		
	abs_rotation += up_direction.angle_to(n_direction)
	up_direction = up_direction.rotated(up_direction.angle_to(n_direction))
	#up_direction =up_direction.rotated(stepify(up_direction.angle_to(n_direction),PI/32))
	
	
	up_direction=up_direction.normalized()
	left_dir = up_direction.orthogonal()
	
	if centered_gravity:
		rotation = snapped(abs_rotation,PI/32)
	else:
		rotation = snapped(abs_rotation,rotation_step)
	
	
	
	pass



func apply_accel(delta,a_vector,v_vector,max_hSpeed=300,max_vSpeed=2000):
	
	if v_vector.dot(left_dir)*a_vector.dot(left_dir)<=0:#HELL YEAH IT WORKS
		v_vector = v_vector.move_toward(up_direction*up_direction.dot(v_vector),12.5*frixion*delta*speed_scale)
	if floating:
		if v_vector.dot(up_direction)*a_vector.dot(up_direction)<=0:#HELL YEAH IT WORKS
			v_vector = v_vector.move_toward(left_dir*left_dir.dot(v_vector),12.5*frixion*delta*speed_scale)
	
	v_vector += a_vector*speed_scale
	#v_vector = v_vector.clamp(max_hSpeed*left_dir-2000*up_direction,-max_hSpeed*left_dir+1000*up_direction)
	
	#the line below limits the strength of the vector, it's ugly but I didn't know how to do differently at the time.
	v_vector = left_dir*min(abs(max_hSpeed*left_dir.dot(left_dir)),abs(v_vector.dot(left_dir)))*sign(v_vector.dot(left_dir))   +   up_direction*min(abs(max_vSpeed*up_direction.dot(up_direction)),abs(v_vector.dot(up_direction)))*sign(v_vector.dot(up_direction))
	
	
	
	return v_vector
#	print(v_vector)#for tests
	#return v_vector.limit_length(max_velocity)





func change_floating():#change this name, it's so bad
	"""changes the movement type and changes the character's animations"""
	up_direction=Vector2.UP
	floating=not floating
	animation_prefix=get_animation_prefix()
	return animation_prefix

func get_animation_prefix():
	if floating:
		animation_prefix="top_down"#maybe change to animation_prefix="TD"
	else:
		animation_prefix="jumper"#maybe change to animation_prefix="PL"     #PL==plateformer
	return animation_prefix






