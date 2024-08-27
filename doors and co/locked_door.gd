extends Node2D

var player_is_there=false

var player :CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_is_there and Input.is_action_pressed("Interract") and (player.held_keys>=1):
		player.held_keys-=1
		queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	player_is_there=true
	player=body
	#show tooltip : "press {key assigned to Interract} to open"


func _on_area_2d_body_exited(body: Node2D) -> void:
	player_is_there=false
	player=body
	#hide tooltip
