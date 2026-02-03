extends PlayableCharacter

@onready var world = $".."

@export var level:PackedScene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_monke = GlobalVariables.is_monke
var speed_scale = 1.0
@export var hp_max : int:
	set(value):
		hp_max=value
		current_hp=value
var current_hp : int:
	set(value):
		current_hp=min(value,hp_max)
#var velocity = Vector2.ZERO
var stuck : bool
var animation_prefix=""
var floating=false #is not affected by gravity ?




@onready var animation_state_machine:AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

var dynamic_left_perception=false

var respawn_point=Vector2.ZERO
var last_position_on_floor:Vector2

var frixion = 750

var held_keys=0 #number of unused keys the player currently has.
var gravity=-1000.0  #gravity strength
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
var mass = 1
var gravity_point=null
var gravity_vect = -up_direction


var is_punching = false

var pickup_list = []
var held_objects = {
	"key":0
}
# Called when the node enters the scene tree for the first time.
func _ready():
	$Scare/ScareHitbox.disabled = true
	$Punch/punchhitbox.disabled = true
	
	is_monke = GlobalVariables.is_monke
	
	$Enki.visible = is_monke
	$Aerin.visible = not(is_monke)
	
	$AnimationPlayer.play("Enki_idle")
	$AnimationPlayer.animation_changed.connect(dispay_animation)
	$Pickup_range.area_entered.connect(_on_pickup_range_obj_entered)
	$Pickup_range.body_entered.connect(_on_pickup_range_obj_entered)
	$Pickup_range.area_exited.connect(_on_pickup_range_obj_exited)
	$Pickup_range.body_exited.connect(_on_pickup_range_obj_exited)
	$AnimationPlayer.animation_finished.connect(update_character_sprite_direction)
	
	#define movement characteristics
	set_jump_height(3.5)
	
	
	
	held_keys=GlobalVariables.held_keys
	hp_max=GlobalVariables.max_hp
	current_hp=GlobalVariables.current_player_hp
	
	
	$HealthBarLayer.hide_hp_fruit(current_hp)
	
	
	
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

func dispay_animation(_old_animation,new_animation):
	print(new_animation)

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
	else:
		if Input.is_action_pressed("ui_o") and Input.is_action_pressed("ui_y"):
				Events.to_credits()
	
	
	if Input.is_action_just_pressed("Grab"):
		grab()
	
	
	
	
	if not floating:
		update_up_direction()
	if is_on_floor():
		last_position_on_floor=position
	
	if Input.is_action_pressed("ui_a"):
		print(rotation_degrees)
	
	#$AnimationTree.set("parameters/Enki/conditions/is_in_air", not(is_on_floor()))
	#$AnimationTree.set("parameters/Enki/conditions/is_jumping", is_on_floor() and Input.is_action_just_pressed("jump"))
	#$AnimationTree.set("parameters/Enki/conditions/is_moving_on_ground", is_on_floor() and (velocity.dot(left_dir) != 0))
	#$AnimationTree.set("parameters/Enki/conditions/is_on_ground", is_on_floor())
	#$AnimationTree.set("parameters/Enki/Airborne/fall_loop/conditions/is_on_ground", is_on_floor())
	#$AnimationTree.set("parameters/Enki/conditions/idle", is_on_floor() and (velocity.dot(left_dir) == 0))
	#$AnimationTree.set("parameters/Enki/Airborne/Rise_up_loop/conditions/is_falling", not(is_on_floor()) and (velocity.dot(up_direction)<0))
	#
	#$AnimationTree.set("parameters/Enki/conditions/is_moving_on_ground", is_on_floor and (velocity.x != 0))
	
	p_mvt(delta)



#func _physics_process(delta):
#	
#
#
#	pass





func update_direction_on_touch_ground():
	pass




'
'
func p_mvt(delta):
	
	var vec_gravity = up_direction*gravity
	
	#print(pickup_list.size())
	
	test_impacts()
	
	if Input.is_action_just_pressed("Swap") :
		if GlobalVariables.can_swap_char:
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
		accel+=jump_(delta,Input.is_action_pressed("ui_up"))
		
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

func update_character_sprite_direction():
	if (velocity.dot(up_direction.rotated(-PI/2))==0):return
	if $Enki/Idle.flip_h!=(velocity.dot(up_direction.rotated(-PI/2))<=0):
		$Enki/Idle.flip_h=velocity.dot(up_direction.rotated(-PI/2))<=0
		$Enki/Run.flip_h=$Enki/Idle.flip_h
		$Enki/Punch.flip_h=$Enki/Idle.flip_h
		$Enki/Jump.flip_h=$Enki/Idle.flip_h
		$Enki/Death.flip_h=$Enki/Idle.flip_h
		if $Enki/Idle.flip_h:
			$Punch.position.x = abs($Punch.position.x)
			$Scare.position.x = abs($Scare.position.x)
		else:
			$Punch.position.x = -abs($Punch.position.x)
			$Scare.position.x = -abs($Scare.position.x)
	

func update_animation_monke(input_vector:Vector2):
	
	var cur_act_unstoppable:bool = (($AnimationPlayer.current_animation == "Enki_punch") || ($AnimationPlayer.current_animation == "Enki_grab") || ($AnimationPlayer.current_animation == "Enki_jump"))
	#if !stuck :#Why ?
	
	if !cur_act_unstoppable:
		if input_vector.length_squared()!=0:
			#TODO punching allows to move backwards even after the punch, correct that
			update_character_sprite_direction()
		
		
		if Input.is_action_just_pressed("Punch") and $PunchCooldown.is_stopped():
			animation_state_machine.travel("Enki_punch")
			$PunchCooldown.start()
		if Input.is_action_just_pressed("Grab"):
			grab()
		
		if is_on_floor():
			if input_vector.x!=0:
				animation_state_machine.travel("Enki/Run")
			else:
				animation_state_machine.travel("Enki/Idle")
		else:
			if  velocity.y > 0:
				animation_state_machine.travel("Enki/Airborne/Rise_Up")
			
			if  velocity.y < 0:
				animation_state_machine.travel("Enki/Airborne/Fall")
			
		


func update_animation_ghost(input_vector:Vector2):
	
	var cur_act_unstoppable = ($AnimationPlayer.current_animation == "GHOST_player_punch") || ($AnimationPlayer.current_animation == "GHOST_player_grab")
	
	
	if Input.is_action_pressed("ui_right") and $AnimationPlayer.current_animation != "GHOST_player_scare":
		if $Punch/punchhitbox.position.x < 0 or $Scare/ScareHitbox.position.x < 0:
			$Punch/punchhitbox.position.x = $Punch/punchhitbox.position.x * -1
			$Scare/ScareHitbox.position.x = $Scare/ScareHitbox.position.x * -1
		$Aerin.flip_h = true
		$Enki.flip_h = true
	if Input.is_action_pressed("ui_left") and $AnimationPlayer.current_animation != "GHOST_player_scare":
		if $Punch/punchhitbox.position.x > 0 or $Scare/ScareHitbox.position.x > 0:
			$Punch/punchhitbox.position.x = $Punch/punchhitbox.position.x * -1
			$Scare/ScareHitbox.position.x = $Scare/ScareHitbox.position.x * -1
		$Aerin.flip_h = false
		$Enki.flip_h = false

	if $AnimationPlayer.current_animation != "GHOST_player_scare":
		$AnimationPlayer.play("GHOST_player_idle")
	
	if Input.is_action_just_pressed("Punch") and $PunchCooldown.is_stopped():
		$AnimationPlayer.play("GHOST_player_scare")
		$PunchCooldown.start()







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
	if ($AnimationPlayer.current_animation == "Enki_punch"):
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
	if $Invicible.is_stopped() :
		current_hp -= hp_lost
		print("Degat", current_hp)
		GlobalVariables.current_player_hp-=hp_lost
		if reset_position:
			reset_position()
		
		$HealthBarLayer.hide_hp_fruit(current_hp)
	
		if current_hp <= 0 :
			game_over()
		$Invicible.start()
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
	#await $AnimationPlayer.play("Enki_death")
	Events.player_died.emit()
	pass



func save():
	GlobalVariables.last_save_point=get_tree().current_scene.scene_file_path


func grab():
	if pickup_list!=[]:
		held_objects.get_or_add(pickup_list[0].get_meta("name",""),0)
		held_objects[pickup_list[0].get_meta("name","unlisted")]+=1
		
		if pickup_list[0].has_method(&"pick_up") :
			pickup_list[0].pick_up()
		else:
			pickup_list[0].queue_free()
			push_error("grab : object in pickup_list cannop be picked up")


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

func _on_pickup_range_obj_entered(obj):
	#if body.is_in_group("Grab"):
		#pickup_list.insert(pickup_list.size(), body)
		#print('Loot Entered')
		#print(pickup_list.size())
		pickup_list.append(obj)
		print('Loot Entered')
		print(pickup_list.size())
	

func _on_pickup_range_obj_exited(obj):
	pickup_list.erase(obj)
	print('Loot Exited')
	print(pickup_list.size())





func _on_char_switch_timeout():
	print('hp : ', current_hp, ", max : ", hp_max)
	if is_monke :
		$Enki.visible = false
		$Aerin.visible = true
		height_of_jump = 1.5
	else :
		$Enki.visible = true
		$Aerin.visible = false
		height_of_jump = 3.5
	is_monke = !is_monke
	GlobalVariables.is_monke = !GlobalVariables.is_monke
	stuck = false
	 # Replace with function body.


func _on_punch_body_entered(body: Node2D) -> void:
	body.position.y-=30
	pass


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if $Invicible.is_stopped() :
		print("damage")
		lose_hp(body.get_meta("damage_dealt",0),body.get_meta("resets_position",0))
		$Invicible.start()
