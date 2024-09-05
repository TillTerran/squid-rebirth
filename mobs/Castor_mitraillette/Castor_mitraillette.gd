extends CharacterBody2D
var projectile= preload("res://mobs/Castor_mitraillette/projectile/projectile.tscn")
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravite=_gravity
var player=null
var player_chase=false
var hauteur_max=100
var facteur_vitesse=2
@export var nb_tir=1
@export var stun_time:float=1.0
@export var HP:int=4
@onready var animation=$AnimationPlayer
var tir_actuel=0
var direction=-1
var speed=50
enum STATE {
	IDLE,
	WALK,
	ATTACK,
	DEATH,
}
var Castor_state=STATE.IDLE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match Castor_state:
		STATE.IDLE:
			animation.play("Idle")
			velocity.y+=gravite*delta
			velocity.x=0
		STATE.WALK:
			animation.play("Walk")
			velocity.y+=gravite*delta
			velocity.x=speed*direction
		STATE.ATTACK:
			animation.play("Attack")
			velocity.y+=gravite*delta
			velocity.x=0
			if player!=null:
				chase_player()
		STATE.DEATH:
			velocity=Vector2()
			animation.play("Death")
	move_and_slide()
	#print(STATE.keys()[Castor_state])

func chase_player():
	if player_chase:
		var position_ennemi = global_position  # Position actuelle de l'ennemi
		var position_joueur = player.global_position  # Position du joueur
		if (position_ennemi.x-position_joueur.x>0):
			get_node("AnimatedSprite2D").flip_h=false
		else:
			get_node("AnimatedSprite2D").flip_h=true
func _on_projectile_timer_timeout():
	if player!=null:
		if tir_actuel<nb_tir:
			var position_ennemi = global_position  # Position actuelle de l'ennemi
			var position_joueur = player.global_position  # Position du joueur
			var hauteur_max_reel= -(position_joueur.y-position_ennemi.y)+hauteur_max
			#if hauteur_max_reel!=0:
				#position_joueur.x-=position_ennemi.y-position_joueur.y
			var vitesse_initiale = calculer_vitesse_initiale(position_ennemi, position_joueur, hauteur_max_reel)
			
			
			var Projectile = projectile.instantiate()  # Crée une instance de ton projectile
			get_tree().current_scene.add_child(Projectile)
			Projectile.position = position_ennemi
			Projectile.lancer(vitesse_initiale)
			tir_actuel+=1
			$ProjectileTimer.start()
		else:
			$Reloading.start()

func _on_detection_area_player_body_entered(body):
	player=body
	$Jump_before_attack.start()
	#velocity.y=-100


func _on_reloading_timeout():
	tir_actuel=0
	$ProjectileTimer.start()

func _on_direction_timeout():
	direction=direction*(-1)
	Castor_state=STATE.IDLE
	if direction==-1:
		$AnimatedSprite2D.flip_h=false
	elif direction==1:
		$AnimatedSprite2D.flip_h=true
	$WaitToChangeDirection.start()

func _on_detection_area_player_body_exited(body):
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
	Castor_state=STATE.IDLE
	$WaitToChangeDirection.start()
	player=null
	$Reloading.stop()





func _on_wait_to_change_direction_timeout():
	Castor_state=STATE.WALK
	#print("change direction")
	$Direction.start()




func _on_jump_before_attack_timeout():
	player_chase=true
	Castor_state=STATE.ATTACK
	direction=0
	$WaitToChangeDirection.stop()
	$Direction.stop()
	#$Reloading.start()
	print("Jump")


func _on_animated_sprite_2d_animation_looped():
	pass

func fire():
	if player!=null:
		if tir_actuel<nb_tir:
			var position_ennemi = global_position  # Position actuelle de l'ennemi
			var position_joueur = player.global_position  # Position du joueur
			var vitesse_initiale = calculer_vitesse_initiale(position_ennemi, position_joueur, hauteur_max)

			var Projectile = projectile.instantiate()  # Crée une instance de ton projectile
			get_tree().current_scene.add_child(Projectile)
			Projectile.position = position_ennemi
			Projectile.lancer(vitesse_initiale)
			#(tir_actuel+=1
			#$ProjectileTimer.start()
		else:
			#$Reloading.start()
			pass
func calculer_vitesse_initiale(position_ennemi, position_joueur, hauteur_max_projectile):#hauteur inutilisée
	var distance = position_joueur - position_ennemi
	var temps_de_vol = sqrt(abs(distance.x))/16
	var vitesse_x = distance.x /(temps_de_vol)
	var vitesse_y=0
	vitesse_y = distance.y/(temps_de_vol) - gravite*temps_de_vol/2
	print(temps_de_vol)
	print(vitesse_y)
	print(vitesse_x)

	return Vector2(vitesse_x, vitesse_y)  # Applique le facteur de vitesse

func _on_animated_sprite_2d_frame_changed():
	if ($AnimatedSprite2D.get_animation())=="attack":
		if $AnimatedSprite2D.get_frame()==7:
			fire()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Stun"):
		Castor_state=STATE.IDLE
		await get_tree().create_timer(stun_time).timeout
		print("Stun")
		Castor_state=STATE.ATTACK
	else:
		hurt()

func death():
	Castor_state=STATE.DEATH
	await animation.animation_finished
	print("Death")
	queue_free()
	
func hurt():
	if HP<=0:
		death()
	else:
		print("-2")
		HP-=2


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Ouille")
	hurt()
