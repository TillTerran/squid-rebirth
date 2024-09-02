extends Area2D


var direction=null
var speed=10
var _gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravite=_gravity
var vitesse = Vector2()
var attack_strength=2
# Called when the node enters the scene tree for the first time.
func lancer(vitesse_initiale):
	vitesse=vitesse_initiale-Vector2(0,gravite/60)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vitesse.y += gravite * delta
	position += vitesse * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body:Node2D):
	if !body.is_in_group("Castor_mitraillette"):
		if body.has_method(&"lose_hp"):
			body.lose_hp(attack_strength)
		queue_free()
