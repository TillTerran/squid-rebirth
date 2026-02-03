extends CharacterBody2D

var pos=null
@export var speed=300
var player=null
var player_chase=null
var gravity = 1.75*ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_height=-350
@export var attack_strength=2
var target_position=Vector2(0,0)
var pos_init=null

#Onyx different state
enum STATE {
	FLY,
	ON_GROUND,
	FALL,
	WAITING,
	FLY_AWAY,
	BACK_TO_POSITION,
	DEATH
}
var Onyx_state=STATE.WAITING
# Called when the node enters the scene tree for the first time.
func _ready():
	pos_init=global_position #Init the initial position of the Onyx
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player!=null:
		if is_on_floor():
			velocity=Vector2(0,0)
		match Onyx_state:
			STATE.FALL:
				velocity.y += gravity * delta
				#print("fall")
				$AnimatedSprite2D.play("Fall")
				if is_on_floor():
					Onyx_state=STATE.ON_GROUND
			STATE.ON_GROUND:
				$PositionTimer.start()
				print("Position on ground")
				Onyx_state=STATE.WAITING
			STATE.WAITING:
				$AnimatedSprite2D.play("Idle")
				fall()
			STATE.FLY:
				velocity.y=0
				$AnimatedSprite2D.play("Fly")
				chase_player()
				print(player_chase)
			STATE.FLY_AWAY:
				velocity.y=jump_height
			STATE.BACK_TO_POSITION:
				back_to_position(delta)
			STATE.DEATH:
				$PositionTimer.stop()
				death()
		move_and_slide()
		#print(STATE.keys()[Onyx_state])
	else:
		match Onyx_state:
			STATE.BACK_TO_POSITION:
				back_to_position(delta)
			STATE.FALL:
				velocity.y += gravity * delta
				if is_on_floor():
					Onyx_state=STATE.BACK_TO_POSITION
		move_and_slide()
		#print(STATE.keys()[Onyx_state])
		
func _on_detection_area_player_body_entered(body):
	player=body
	player_chase=true
	$WaitingTimerGoBackToPosition.stop()
		
func _on_detection_area_player_body_exited(body):
	
	player=null
	player_chase=false
	if not $WaitingTimerGoBackToPosition.is_inside_tree():return
	$WaitingTimerGoBackToPosition.start()

func fall():
	#When the player is under the Onyx, he fall on the ground
	pos=(player.global_position - self.global_position).normalized()
	
	if (pos.y>0.99):
		Onyx_state=STATE.FALL
		
func chase_player():
	#The Onyx follow the player and fall on him when he is close enough
	if player_chase:
			pos=(player.global_position - self.global_position).normalized()
			var pos_rela_joueur=(player.global_position - self.global_position)
			var direction = (player.global_position - self.position).normalized()* speed
			if direction.x>0:
					get_node("AnimatedSprite2D").flip_h=true
			else:
					get_node("AnimatedSprite2D").flip_h = false
			velocity.x = sign(direction.x)*speed
			print(sqrt(abs(4*pos_rela_joueur.y*gravity)))
			print(abs(pos_rela_joueur.x/velocity.x))
			if abs(pos_rela_joueur.x/velocity.x) < sqrt(abs(4*pos_rela_joueur.y*gravity)):#temps pour atteindre le x du joueur < temps pour atteindre le y du joueur
				Onyx_state=STATE.FALL
				pass
				
			
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.01)
		velocity.x = 0  # Stop horizontal movement when `player_chase` is disabled

#When Onyx is on the ground, he fly away
func _on_position_timer_timeout():
	Onyx_state=STATE.FLY_AWAY
	print("Position Timeout")
	$Timer.start()
	
func _on_waiting_timer_go_back_to_position_timeout():
	Onyx_state=STATE.BACK_TO_POSITION

#When the player is out of the DetectionAreaPlayer, he go back to his position
func back_to_position(delta):
	var direction = pos_init - global_position
	var distance_to_target = direction.length()
	
	# Si l'ennemi est très proche de la position initiale, on l'arrête
	if distance_to_target < 0.1:  # Tolérance pour considérer que l'ennemi est arrivé
		velocity = Vector2()  # Stoppe le mouvement
		global_position = pos_init  # Assure que l'ennemi est bien à sa position initiale
		Onyx_state=STATE.WAITING
	else:
		# Normalise la direction et ajuste la vitesse en conséquence
		direction = direction.normalized()
		velocity = direction * speed

	# Mise à jour de la position en fonction de la vélocité calculée
	global_position += velocity * delta
#		
#		
func _on_hitbox_body_entered(body):
	if body.has_method(&"lose_hp"):
			body.lose_hp(attack_strength)
func death():
	await $AnimatedSprite2D.animation_finished
	queue_free()


#When the Onyx finish to fly away, he fly and chase the player
func _on_timer_timeout():
	Onyx_state=STATE.FLY
	print("FLY")

#When the Onyx is on his initial position, he wait for the player
func _on_navigation_agent_2d_target_reached():
	Onyx_state=STATE.WAITING


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Stun"):
		Onyx_state=STATE.WAITING
		await get_tree().create_timer(1.0).timeout
		print("Stun")
		Onyx_state=STATE.FLY


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Stun"):
		Onyx_state=STATE.WAITING
		await get_tree().create_timer(1.0).timeout
		print("Stun")
		Onyx_state=STATE.FLY


func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.play("Death")
	Onyx_state=STATE.DEATH
