extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation=$AnimationPlayer
@onready var Ecureuil=$"."
var player_chase=false
var player=null
var change_direction=false
@export var attack_strength=2
# Called when the node enters the scene tree for the first time.
enum STATE {
	IDLE,
	RUN,
	ATTACK,
}
var Ecureuil_state=STATE.IDLE
@export var direction=["Right","Left"]
@export var choose_direction="Right"
@export var speed=100
func _ready() -> void:
	if choose_direction==direction[0]:
		animation.play("IdleRight")
	else:
		animation.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.y+=gravity*delta
	match Ecureuil_state:
		STATE.IDLE:
			velocity.x=0
		STATE.RUN:
			if player!=null:
				chase_player()
		STATE.ATTACK:
			special_attack()
	move_and_slide()

func chase_player() -> void:
	if player_chase:
		var direction = (player.global_position - self.position).normalized()
		if !change_direction:
			if direction.x>0:
				animation.play("Running_Right")
				change_direction==true
			else:
				animation.play("Running")
		velocity.x=(direction.x*speed)
		#print(velocity)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.01)
		velocity.x = 0  # Stop horizontal movement when `player_chase` is disabled

func special_attack()->void:
	if player_chase:
		var direction = (player.global_position - self.position).normalized()
		var position_ennemi = global_position  # Position actuelle de l'ennemi
		var position_joueur = player.global_position  # Position du joueur
		velocity.x=sign(direction.x*speed)
func _on_detection_area_body_entered(body: Node2D) -> void:
	player=body
	player_chase=true
	var position_ennemi = global_position  # Position actuelle de l'ennemi
	var position_joueur = body.global_position  # Position du joueur
	if (position_ennemi.x-position_joueur.x>0):
		animation.play("StartRunning")
	else:
		animation.play("StartRunningRight")
	Ecureuil_state=STATE.RUN
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var direction=(global_position- player.global_position).normalized()
	if anim_name=="StartRunning" or anim_name=="StartRunningRight":
		print("startRunning")
		if (direction.x>0):
			animation.play("Running")
		else:
			animation.play("Running_Right")
		Ecureuil_state=STATE.RUN
	elif anim_name=="Running" or anim_name=="Running_Right":
		change_direction==true
	elif anim_name=="Attack" or anim_name=="Attack_Right":
		if (direction.x>0):
			print(true)
			animation.play("Attack_right")
		else:
			animation.play("Attack")
func _on_attack_detection_area_body_entered(body: Node2D) -> void:
	if body==player:
		var position_ennemi = global_position  # Position actuelle de l'ennemi
		var position_joueur = body.global_position  # Position du joueur
		if (position_ennemi.x-position_joueur.x<0):
			print(true)
			animation.play("Attack_right")
		else:
			animation.play("Attack")
		Ecureuil_state=STATE.ATTACK


func _on_attack_detection_area_body_exited(body: Node2D) -> void:
	if body==player:
		var position_ennemi = global_position  # Position actuelle de l'ennemi
		var position_joueur = body.global_position  # Position du joueur
		if (position_ennemi.x-position_joueur.x<0):
			animation.play("StartRunningRight")
		else:
			animation.play("StartRunning")
		Ecureuil_state=STATE.RUN


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body==player:
		Ecureuil_state=STATE.IDLE
		player_chase=false
		player=null
		var position_ennemi = global_position  # Position actuelle de l'ennemi
		var position_joueur = body.global_position  # Position du joueur
		if (position_ennemi.x-position_joueur.x<0):
			animation.play("IdleRight")
		else:
			animation.play("Idle")


func _on_chainsaw_area_body_entered(body: Node2D) -> void:
	if body.has_method(&"lose_hp"):
			body.lose_hp(attack_strength)

func death():
	print("Death")
	animation.play("Death")
	await animation.animation_finished
	queue_free()
