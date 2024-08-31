extends CharacterBody2D

@export var speed=100
var projectile = preload("res://mobs/totem_claquette/projectile/totem_claquette_projectile.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_chase = false
var player = null
var totem=null
var self_width = null
var self_lenght=null
var lenght_bottom_totem=null
var width_bottom_totem=null
var fusion = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self_width = get_node("HitboxTopTotem").shape.extents.y * 2
	self_lenght=get_node("HitboxTopTotem").shape.extents.x * 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity * delta
	if fusion==true:
		totem_merge()
	else:
		chase_player()
	move_and_slide()


func _on_detection_area_bottom_totem_body_entered(body):
	if body.is_in_group("BottomTotemClaquette") and body != self:
		totem=body
		fusion=true
		width_bottom_totem=totem.get("self_width")
		lenght_bottom_totem=totem.get("self_lenght")


func _on_detection_area_bottom_totem_body_exited(body):
	if body.is_in_group("BottomTotemClaquette") and body != self:
		totem=null
		fusion=false


func _on_detection_area_player_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_chase = true


func _on_detection_area_player_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		player_chase = false
		
func chase_player():
	if player_chase:
			var direction = (player.global_position - global_position).normalized()* speed
			velocity.x = direction.x 
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.01)
		velocity.x = 0  # Arrête le mouvement horizontal lorsque `player_chase` est désactivé
		
func totem_merge():
		player_chase = false  # Arrête la poursuite du joueur si la fusion est active est active
		var direction = (totem.global_position - self.global_position).normalized()
		velocity.x = direction.x * speed
		if (self.global_position.x<=totem.global_position.x+lenght_bottom_totem+2) and (self.global_position.x>=totem.global_position.x-lenght_bottom_totem-2):
			velocity=Vector2(0,-width_bottom_totem)
			if self.global_position.y<totem.global_position.y-width_bottom_totem:
				velocity.y=10
				velocity.x = direction.x * speed
				if (direction.x<=0.01) and (direction.x>=-0.01):
					fusion=false
					velocity.y=0
		



func _on_projectile_timer_timeout():
	var b = projectile.instantiate()
	get_tree().root.add_child(b)
	b.start(position)
	$ProjectileTimer.wait_time = 2
	$ProjectileTimer.start()
	print("PROJECTILE")
	
