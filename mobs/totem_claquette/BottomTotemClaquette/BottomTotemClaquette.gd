extends CharacterBody2D

@export var speed = 100
var projectile = preload("res://mobs/totem_claquette/projectile/totem_claquette_projectile.tscn")
var player_chase = false
var player = null
var top_totem = false
var bottom_totem=true
var totem=null
var self_width = null
var self_lenght=null
var width_top_totem=null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var fusion = false
var max_totem=2
var nb_totem=0
var projectile_direction=null
enum STATE {
	CHASE,
	MERGE,
	WAITING,
	BACK_TO_POSITION,
}
var BottomTotemState=STATE.WAITING
func _ready():
	self_width = get_node("HitboxBottomTotem").shape.extents.y * 2
	self_lenght= get_node("HitboxBottomTotem").shape.extents.x * 2
func _process(delta):
	velocity.y += gravity * delta  # Apply the gravity
	if fusion:
		BottomTotemState=STATE.MERGE
	match BottomTotemState:
		STATE.WAITING:
			velocity.x=0
		STATE.CHASE:
			chase_player()
		STATE.MERGE:
			if totem!=null:
				velocity=Vector2(0,0)
				fusion=totem.get("fusion")
				if !fusion:
					BottomTotemState=STATE.CHASE
					player_chase=true
			else:
				BottomTotemState=STATE.CHASE
		STATE.BACK_TO_POSITION:
			pass
	move_and_slide()
	#print(STATE.keys()[BottomTotemState]) 

func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true
		BottomTotemState=STATE.CHASE
		$ProjectileTimer.start()

func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		player_chase = false
		$ProjectileTimer.stop()

func _on_detection_area_totem_body_entered(body):
	if body.is_in_group("TopTotemClaquette") and body != self:
		totem=body
		fusion=true

func _on_detection_area_totem_body_exited(body):
	if body.is_in_group("TopTotemClaquette") and body != self:
		bottom_totem=true
		fusion=false
		
#Function to chase the player, the totem goes towards the player and fires a projectile at regular intervals
func chase_player():
	if player_chase:
			var direction = (player.global_position - self.position).normalized()* speed
			if direction.x>0:
					get_node("AnimatedSprite2D").flip_h=true
					projectile_direction=true
			else:
					get_node("AnimatedSprite2D").flip_h = false
					projectile_direction=false
			velocity.x = sign(direction.x)*speed
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.01)
		velocity.x = 0  # Stop horizontal movement when `player_chase` is disabled
		
#When the timer is timeout, a projectile spawn
func _on_projectile_timer_timeout():
	var b = projectile.instantiate()
	get_tree().root.add_child(b)
	b.start(position,projectile_direction)
	$ProjectileTimer.start()

func death():
	queue_free()


func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		death()
