extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed=100
@export var HP:int=4
@export var DamageGiveByPlayer:int=2
@export var attack_strength=2
var direction=-1
enum STATE {
	IDLE,
	WALK,
	ATTACK,
	STUN,
	DEATH
}
var Legrorat_state=STATE.IDLE
@onready var IdleCollision=get_node("AreaIdle/IdleCollision")
@onready var WalkCollision=get_node("AreaWalk/WalkCollision")
@onready var AttackCollision=get_node("AreaAttack/AttackCollision")

var player=null
var player_chase=false
var pos=null
var miss_player=false
var running_direction=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y+=gravity*delta
	match Legrorat_state:
		STATE.IDLE:
			$AnimatedSprite2D.play("idle")
			IdleCollision.disabled=false
			AttackCollision.disabled=true
			WalkCollision.disabled=true
			velocity.y+=gravity*delta
			velocity.x=0
		STATE.WALK:
			$AnimatedSprite2D.play("walk")
			IdleCollision.disabled=true
			AttackCollision.disabled=true
			WalkCollision.disabled=false
			velocity.y+=gravity*delta
			velocity.x=speed*direction
		STATE.ATTACK:
			$AnimatedSprite2D.play("attack")
			IdleCollision.disabled=true
			AttackCollision.disabled=false
			WalkCollision.disabled=true
			velocity.y+=gravity*delta
			velocity.x=0
			if player!=null:
				chase_player()
		STATE.STUN:
			$AnimatedSprite2D.play("idle")
			IdleCollision.disabled=false
			AttackCollision.disabled=true
			WalkCollision.disabled=true
			velocity.y+=gravity*delta
			velocity.x=0
		STATE.DEATH:
				$AnimatedSprite2D.play("Death")
	move_and_slide()
	#print(STATE.keys()[Legrorat_state])



func _on_direction_timeout() -> void:
	direction=direction*(-1)
	Legrorat_state=STATE.IDLE
	if direction==-1:
		$AnimatedSprite2D.flip_h=false
	elif direction==1:
		$AnimatedSprite2D.flip_h=true
	$WaitToChangeDirection.start(2)


func _on_wait_to_change_direction_timeout() -> void:
	Legrorat_state=STATE.WALK
	#print("change direction")
	$Direction.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_chase=true
	player=body
	$Direction.stop()
	$WaitToChangeDirection.stop()
	direction=0
	Legrorat_state=STATE.ATTACK
	pos=(player.global_position - self.global_position).normalized()
	if pos.x>0:
		running_direction=1
	else:
		running_direction=-1
	#$Run.start()

func chase_player() -> void:
	if player_chase:
		pos=(player.global_position - self.global_position).normalized()
		if running_direction==1:
			get_node("AnimatedSprite2D").flip_h=true
			if pos.x<0:
				if !miss_player:
					miss_player=true
					$Run.start()
		elif running_direction==-1:
			get_node("AnimatedSprite2D").flip_h = false
			if pos.x>0:
				if !miss_player:
					miss_player=true
					$Run.start()
		velocity.x=running_direction*speed
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.01)
		velocity.x = 0  # Stop horizontal movement when `player_chase` is disabled
	
func _on_run_timeout() -> void:
	running_direction=running_direction*(-1)
	miss_player=false
	print(running_direction)



func _on_area_attack_area_entered(area: Area2D) -> void:
	if area.is_in_group("Stun"):
		print("Stun")
		Legrorat_state=STATE.STUN
		$Stun.start()
	if Legrorat_state==STATE.IDLE:
		hurt()



func _on_stun_timeout() -> void:
	Legrorat_state=STATE.ATTACK


func _on_area_2d_body_exited(body: Node2D) -> void:
	var position_ennemi = global_position  # Position actuelle de l'ennemi
	var position_joueur = body.global_position  # Position du joueur
	if (position_ennemi.x-position_joueur.x>0):
		get_node("AnimatedSprite2D").flip_h=false
		direction=-1
	else:
		get_node("AnimatedSprite2D").flip_h=true
		direction=1
	player_chase=false
	print("Exit body")
	Legrorat_state=STATE.IDLE
	$WaitToChangeDirection.start(2)
	player=null


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	hurt()
	
func death():
	await $AnimatedSprite2D.animation_finished
	print("Death")
	queue_free()

func hurt():
	if HP<=0:
		Legrorat_state=STATE.DEATH
		death()
	elif Legrorat_state==STATE.ATTACK:
		pass
	else:
		HP-=DamageGiveByPlayer
		print("Ouille")


func _on_area_attack_body_entered(body: Node2D) -> void:
		if body.has_method(&"lose_hp"):
			body.lose_hp(attack_strength)
