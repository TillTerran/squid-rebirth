extends Area2D


var direction=null
var gravite=9.80
var vitesse = Vector2()
var speed=10
var attack_strength=2
# Called when the node enters the scene tree for the first time.
func lancer(vitesse_initiale):
	vitesse=vitesse_initiale
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vitesse.y += gravite * delta*speed
	position += vitesse * delta*speed


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body:Node2D):
	if !body.is_in_group("Castor_mitraillette"):
		if body.has_method(&"lose_hp"):
			body.lose_hp(attack_strength)
		queue_free()
