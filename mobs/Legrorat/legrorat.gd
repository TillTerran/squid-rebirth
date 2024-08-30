extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed=100
var direction=-1
enum STATE {
	IDLE,
	WALK,
	ATTACK,
	STUN,
}
var Legrorat_state=STATE.IDLE
@onready var IdleCollision=get_node("AreaIdle/IdleCollision")
@onready var AttackCollision=get_node("AreaWalk/WalkCollision")
@onready var WalkCollision=get_node("AreaAttack/AttackCollision")

var player=null
var player_chase=false
var pos=null
var miss_player=true
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
			where_is_player()
			if player!=null:
				chase_player()
		STATE.STUN:
			pass
	move_and_slide()



func _on_direction_timeout() -> void:
	direction=direction*(-1)
	Legrorat_state=STATE.IDLE
	if direction==-1:
		$AnimatedSprite2D.flip_h=false
	elif direction==1:
		$AnimatedSprite2D.flip_h=true
	$WaitToChangeDirection.start()


func _on_wait_to_change_direction_timeout() -> void:
	Legrorat_state=STATE.WALK
	print("change direction")
	$Direction.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_chase=true
	player=body
	$Direction.stop()
	$WaitToChangeDirection.stop()
	direction=0
	Legrorat_state=STATE.ATTACK
	pos=(player.global_position - self.global_position).normalized()
	$Run.start()

func chase_player() -> void:
	if player_chase:
		if miss_player:
			var chase_direction = pos* speed
			if chase_direction.x>0:
					get_node("AnimatedSprite2D").flip_h=true
			else:
					get_node("AnimatedSprite2D").flip_h = false
			velocity.x = sign(chase_direction.x)*speed
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.01)
		velocity.x = 0  # Stop horizontal movement when `player_chase` is disabled

func where_is_player() -> void:
	pass
	
func _on_run_timeout() -> void:
	pos=(player.global_position - self.global_position).normalized()
	$Run.start()
