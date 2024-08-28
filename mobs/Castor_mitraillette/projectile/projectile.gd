extends Area2D



var direction=null
var gravite=9.80
var vitesse = Vector2()
var speed=10
# Called when the node enters the scene tree for the first time.
func lancer(vitesse_initiale):
	vitesse=vitesse_initiale
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vitesse.y += gravite * delta*speed
	position += vitesse * delta*speed


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	print("ouch")
	body.lose_hp(1)
	queue_free()
