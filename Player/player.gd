extends CharacterBody2D

@onready var world = $".."

@export var level:PackedScene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_monke = true
var speed_scale = 1.0
var hp_max = 4
var current_hp = 3
#var velocity = Vector2.ZERO
var stuck
var animation_prefix=""
var floating=false #is not affected by gravity ?

@export var height_of_jump=3.5 #height of the jump in tiles
@export var tile_size=16.0#size of a tile in pixel

var dynamic_left_perception=false

var respawn_point=Vector2.ZERO
var last_position_on_floor:Vector2

var frixion = 750

var held_keys=0 #number of unused keys the player currently has.
var gravity=-1000.0  #gravity strength
var p_walkaccel = 500 
var max_velocity = 2000
var jump= sqrt(2.0*abs(gravity)*(1+height_of_jump*tile_size))# 16 pixel per tile; expected 

var coyote_jump = 0
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
var mass = 1
var gravity_point=null
var gravity_vect = -up_direction


var is_punching = false
var pickup_list = []
# Called when the node enters the scene tree for the first time.
func _ready():
	
	held_keys=GlobalVariables.held_keys
	hp_max=GlobalVariables.max_hp
	current_hp=GlobalVariables.current_player_hp
	
	
	
	
	
	
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
	held_keys=GlobalVariables.held_keys
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):# try to change to _physics_process
	#if hp_max != current_hp :
	#	print("hp max :", hp_max, " current pv : ", current_hp)
	
	#if area_entered onready var terrain_de_test = $"../terrain de test"
#	if Input.is_action_just_pressed("ui_select"): # obsolete... for now
#		change_gravity_type(not centered_gravity)
#		print("space")
	if !get_window().has_focus():
		get_tree().paused = true
	
	centered_gravity = (gravity_point != null)
	
	if Input.is_action_just_pressed("ui_cancel"):
		#Events.main_menu.emit()
		get_tree().paused=true
		#InGameMenu.
	
	
	
	
	
	if not floating:
		update_up_direction()
	if is_on_floor():
		last_position_on_floor=position
	
	if Input.is_action_pressed("ui_a"):
		print(rotation_degrees)
	
	p_mvt(delta)



#func _physics_process(delta):
#	
#
#
#	pass










'
'
func p_mvt(delta):
	
	var vec_gravity = up_direction*gravity
	
	#print(pickup_list.size())
	
	test_impacts()
	
	if Input.is_action_just_pressed("Swap") :
		$CharSwitch.start()
		stuck = true
	#impacts = []
	var input_vector = Vector2.ZERO
	#var bounced_vec=Vector2.ZERO
	#var floor_normal = 0
	
	
	input_vector = get_inputs(delta,input_vector,vec_gravity)
	if is_monke :
		update_animation_monke(input_vector)
	else :
		update_animation_ghost(input_vector)
	#print(input_vector)
	
	velocity=apply_accel(delta,accel,velocity)
	accel = Vector2.ZERO
	"""if input_vector.x==0:
		input_vector.x = move_toward(input_vector.x,0,frixion)
	"""
	
	if !stuck :
		process_movement()
	

func get_inputs(delta,input_vector:Vector2,vec_gravity:Vector2):
	"""registers the input vectors and adds tehir corresponding accel_vectors to accel"""
	if floating:#changes the movement from plateformer to top-down, ask Phantom for details if needed
		input_vector = left_dir * (Input.get_axis("ui_right","ui_left"))
		input_vector += up_direction  * (Input.get_axis("ui_down","ui_up"))
		accel+=input_vector*p_walkaccel*delta
		
	else:
		input_vector = left_dir * (Input.get_axis("ui_right","ui_left"))
		
		if dynamic_left_perception:
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





func respawn(cause:int)->void:
	if cause == 0:#cause == death
		position=respawn_point
#		set hearts to max (taking current max_health into account)
	if cause == 1:#cause == spikes
		position=last_position_on_floor
	if cause == 2:#cause == undefined yet
		position=last_position_on_floor






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


func update_animation_monke(input_vector):
	
	var cur_act_unstoppable = ($AnimationPlayer.current_animation == "PL_player_punch") || ($AnimationPlayer.current_animation == "PL_player_grab")
	
	if !stuck :
		if Input.is_action_pressed("ui_right") and !cur_act_unstoppable:
			if $Punch/punchhitbox.position.x < 0 :
				$Punch/punchhitbox.position.x = $Punch/punchhitbox.position.x * -1
			$Monke/Run.flip_h = false
			$Monke/Idle.flip_h = false
			$Monke/Punch.flip_h = false
			$Monke/Jump.flip_h = false
		if Input.is_action_pressed("ui_left") and !cur_act_unstoppable:
			if $Punch/punchhitbox.position.x > 0 :
				$Punch/punchhitbox.position.x = $Punch/punchhitbox.position.x * -1
			$Monke/Run.flip_h = true
			$Monke/Idle.flip_h = true
			$Monke/Punch.flip_h = true
			$Monke/Jump.flip_h = true

	if input_vector!=Vector2.ZERO and !cur_act_unstoppable and $AnimationPlayer.current_animation != "PL_player_jump":
		"Deux ligne suivant forcée due au faite ques les sprites sont séparé en plusieurs fichiers"
		$Monke/Idle.visible = false 
		$Monke/Run.visible = true
		$Monke/Jump.visible = false
		$Monke/Punch.visible = false
		$Monke/Death.visible = false
		"$Monke/Run.flip_h = (input_vector.dot(-left_dir)<0)"
		$AnimationPlayer.play("PL_player_run")
	else:
		if !cur_act_unstoppable and $AnimationPlayer.current_animation != "PL_player_grab":
			"Deux ligne suivant forcée due au faite ques les sprites sont séparé en plusieurs fichiers"
			$Monke/Idle.visible = true 
			$Monke/Run.visible = false 
			$Monke/Jump.visible = false
			$Monke/Punch.visible = false
			$Monke/Death.visible = false
			"$Monke/Run.flip_h = (input_vector.dot(-left_dir)<0)"
			$AnimationPlayer.play("PL_player_idle")


	if Input.is_action_just_pressed("Punch") and $PunchCooldown.is_stopped():
		$Monke/Idle.visible = false 
		$Monke/Run.visible = false 
		$Monke/Punch.visible = true
		$Monke/Jump.visible = false
		$Monke/Death.visible = false
		$AnimationPlayer.play("PL_player_punch")
		$PunchCooldown.start()
	
	if Input.is_action_just_pressed("Grab") and !cur_act_unstoppable:
		if pickup_list.size() != 0 :
			var current_pick = pickup_list[0]
			pickup_list.remove_at(0)
			$Monke/Idle.visible = false
			$Monke/Run.visible = false 
			$Monke/Jump.visible = false
			$Monke/Punch.visible = false
			$Monke/Death.visible = true
			$AnimationPlayer.play("PL_player_grab")
			#Et la on peut faire ce qu'on veut avec l'item au sol
			current_pick.queue_free()
	
	
	if not is_on_floor() and velocity.y > 0 and !cur_act_unstoppable:
		$Monke/Idle.visible = false 
		$Monke/Run.visible = false 
		$Monke/Punch.visible = false
		$Monke/Jump.visible = true
		$Monke/Death.visible = false
		$AnimationPlayer.play("PL_player_jump")
	
	if not is_on_floor() and velocity.y < 0 and !cur_act_unstoppable:
		$Monke/Idle.visible = false 
		$Monke/Run.visible = false 
		$Monke/Punch.visible = false
		$Monke/Jump.visible = true
		$Monke/Death.visible = false
		$AnimationPlayer.play("PL_player_fall")

func update_animation_ghost(input_vector):
	
	var cur_act_unstoppable = ($AnimationPlayer.current_animation == "GHOST_player_punch") || ($AnimationPlayer.current_animation == "GHOST_player_grab")
	
	
	if Input.is_action_just_pressed("ui_right") and $AnimationPlayer.current_animation != "PL_player_punch":
		if $Punch/punchhitbox.position.x < 0 :
			$Punch/punchhitbox.position.x = $Punch/punchhitbox.position.x * -1
		$Ghost/Run.flip_h = false
		$Ghost/Idle.flip_h = false
		$Ghost/Punch.flip_h = false
		$Ghost/Jump.flip_h = false
	if Input.is_action_just_pressed("ui_left") and $AnimationPlayer.current_animation != "PL_player_punch":
		if $Punch/punchhitbox.position.x > 0 :
			$Punch/punchhitbox.position.x = $Punch/punchhitbox.position.x * -1
		$Ghost/Run.flip_h = true
		$Ghost/Idle.flip_h = true
		$Ghost/Punch.flip_h = true
		$Ghost/Jump.flip_h = true

	if input_vector!=Vector2.ZERO and $AnimationPlayer.current_animation != "PL_player_punch" and $AnimationPlayer.current_animation != "PL_player_jump":
		"Deux ligne suivant forcée due au faite ques les sprites sont séparé en plusieurs fichiers"
		$Ghost/Idle.visible = false 
		$Ghost/Run.visible = true 
		$Ghost/Jump.visible = false
		$Ghost/Punch.visible = false
		"$Ghost/Run.flip_h = (input_vector.dot(-left_dir)<0)"
		$AnimationPlayer.play("PL_player_run")
	else:
		if $AnimationPlayer.current_animation != "PL_player_punch":
			"Deux ligne suivant forcée due au faite ques les sprites sont séparé en plusieurs fichiers"
			$Ghost/Idle.visible = true 
			$Ghost/Run.visible = false 
			$Ghost/Jump.visible = false
			$Ghost/Punch.visible = false
			"$Ghost/Run.flip_h = (input_vector.dot(-left_dir)<0)"
			$AnimationPlayer.play("GHOST_player_idle")
	if Input.is_action_just_pressed("Punch") and $PunchCooldown.is_stopped():
		$Ghost/Idle.visible = false 
		$Ghost/Run.visible = false 
		$Ghost/Punch.visible = true
		$Ghost/Jump.visible = false
		$AnimationPlayer.play("PL_player_punch")
		$PunchCooldown.start()
	
	
	if not is_on_floor() and velocity.y > 0 and $AnimationPlayer.current_animation != "PL_player_punch":
		$Ghost/Idle.visible = false 
		$Ghost/Run.visible = false 
		$Ghost/Punch.visible = false
		$Ghost/Jump.visible = true
		$AnimationPlayer.play("PL_player_jump")
	
	if not is_on_floor() and velocity.y < 0 and $AnimationPlayer.current_animation != "PL_player_punch":
		$Ghost/Idle.visible = false 
		$Ghost/Run.visible = false 
		$Ghost/Punch.visible = false
		$Ghost/Jump.visible = true
		$AnimationPlayer.play("PL_player_fall")








#========================================================================================================
#========================================================================================================
#========================================================================================================






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
	if v_vector.dot(left_dir)*a_vector.dot(left_dir)<=1:#HELL YEAH IT WORKS
		v_vector = v_vector.move_toward(up_direction*up_direction.dot(v_vector),12.5*frixion*delta*speed_scale)
	if floating:
		if v_vector.dot(up_direction)*a_vector.dot(up_direction)<=0:#HELL YEAH IT WORKS
			v_vector = v_vector.move_toward(left_dir*left_dir.dot(v_vector),12.5*frixion*delta*speed_scale)
	
	v_vector += a_vector*speed_scale
	#v_vector = v_vector.clamp(max_hSpeed*left_dir-2000*up_direction,-max_hSpeed*left_dir+1000*up_direction)
	
	#the line below limits the strength of the vector, it's ugly but I didn't know how to do differently at the time.
	v_vector = left_dir*min(abs(max_hSpeed*left_dir.dot(left_dir)),abs(v_vector.dot(left_dir)))*sign(v_vector.dot(left_dir))   +   up_direction*min(abs(max_vSpeed*up_direction.dot(up_direction)),abs(v_vector.dot(up_direction)))*sign(v_vector.dot(up_direction))
	if ($AnimationPlayer.current_animation == "PL_player_punch"):
		v_vector-=left_dir*v_vector.dot(left_dir)*1/4
	
	
	return v_vector
#	print(v_vector)#for tests
	#return v_vector.limit_length(max_velocity)


func reset_position()->void:
	position=respawn_point
	velocity*=0




#========================================================================================================
#========================================================================================================
#========================================================================================================







func add_health() :
	if current_hp < hp_max :
			current_hp = current_hp +1

func add_more_health() :
	if current_hp < hp_max :
			current_hp = (current_hp +2) % (hp_max+1)

func lose_hp(hp_lost:int,reset_position:bool =false)->void:
	
	current_hp -= hp_lost
	GlobalVariables.current_player_hp-=hp_lost
	if reset_position:
		reset_position()
	
	if current_hp <= 0 :
		game_over()
	#print(current_hp)



func game_over():
	#if is_monke:
		#$Monke/Idle.visible = false 
		#$Monke/Run.visible = false 
		#$Monke/Punch.visible = false
		#$Monke/Jump.visible = false
	#else:
		#$Ghost/Idle.visible = false 
		#$Ghost/Run.visible = false 
		#$Ghost/Punch.visible = false
		#$Ghost/Jump.visible = false
	#$AnimationPlayer.stop()
	#await $AnimationPlayer.play("PL_player_death")
	Events.player_died.emit()
	pass



func save():
	GlobalVariables.last_save_point=get_tree().current_scene.scene_file_path






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


func _on_loot_range_body_entered(body):
	if body.is_in_group("Heal") :
		add_health()
	if body.is_in_group("Big Heal") :
		add_more_health()
	if body.is_in_group("Drop") :
		body.queue_free()

func _on_pickup_range_body_entered(body):
	if body.is_in_group("Grab"):
		pickup_list.insert(pickup_list.size(), body)
		print('Loot Entered')
		print(pickup_list.size())

func _on_pickup_range_body_exited(body):
	if body.is_in_group("Grab"):
		pickup_list.erase(body)
		print('Loot Exited')
		print(pickup_list.size())



func _on_char_switch_timeout():
	print('hp : ', current_hp, ", max : ", hp_max)
	if is_monke :
		$Monke.visible = false
		$Ghost.visible = true
		height_of_jump = 1.5
	else :
		$Monke.visible = true
		$Ghost.visible = false
		height_of_jump = 3.5
	is_monke = !is_monke
	stuck = false
	 # Replace with function body.


func _on_punch_body_entered(body: Node2D) -> void:
	body.position.y-=30
	pass


func _on_hurtbox_body_entered(body: Node2D) -> void:
	lose_hp(body.get_meta("damage_dealt",0),body.get_meta("resets_position",0))
