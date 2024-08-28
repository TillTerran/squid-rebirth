extends CharacterBody2D

var projectile= preload("res://mobs/Castor_mitraillette/projectile/projectile.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravite=9.80
var player=null
var player_chase=false
var hauteur_max=100
var facteur_vitesse=2
@export var nb_tir=3
var tir_actuel=0
var direction=1
var speed=50
# Called when the node enters the scene tree for the first time.
func _ready():
	$Direction.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y+=gravity*delta
	velocity.x=speed*direction
	if player!=null:
		chase_player()
	move_and_slide()

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
			var vitesse_initiale = calculer_vitesse_initiale(position_ennemi, position_joueur, hauteur_max)

			var Projectile = projectile.instantiate()  # Crée une instance de ton projectile
			get_tree().root.add_child(Projectile)
			Projectile.position = position_ennemi
			Projectile.lancer(vitesse_initiale)
			tir_actuel+=1
			$ProjectileTimer.start()
		else:
			$Reloading.start()

func _on_detection_area_player_body_entered(body):
	if body.is_in_group("Player"):
			player=body
			player_chase=true
			direction=0
			$Reloading.start()

func calculer_vitesse_initiale(position_ennemi, position_joueur, hauteur_max):
	var distance = position_joueur - position_ennemi
	var temps_de_vol = sqrt(2 * hauteur_max / gravite) + sqrt(2 * (hauteur_max - distance.y) / gravite)
	var vitesse_x = distance.x / temps_de_vol
	var vitesse_y = sqrt(2 * gravite * hauteur_max)
	return Vector2(vitesse_x, -vitesse_y)  # Applique le facteur de vitesse



func _on_reloading_timeout():
	tir_actuel=0
	$ProjectileTimer.start()





func _on_direction_timeout():
	direction=direction*(-1)
	if direction==-1:
		get_node("AnimatedSprite2D").flip_h=false
	elif direction==1:
		get_node("AnimatedSprite2D").flip_h=true

func _on_detection_area_player_body_exited(body):
	direction=1
	player_chase=false
	player=null
	$Reloading.stop()
