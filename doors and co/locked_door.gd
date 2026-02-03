extends Area2D

var player_is_there=false

var player :CharacterBody2D

@export var door_number:int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if door_number !=-1:
		if GlobalVariables.opened_doors[door_number]:
			queue_free()
			return
		
		body_entered.connect(_on_player_entered)
		body_exited.connect(_on_player_exited)
	else :
		push_error("ERROR : door_number not updated (get_global)")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_is_there and Input.is_action_pressed("Interract") and (player.held_objects["key"]>=1):
		player.held_objects["key"]-=1
		if door_number !=-1:
			GlobalVariables.opened_doors[door_number]=true
		else :
			push_error("door_number not updated (set_global)")
		queue_free.call_deferred()



func _on_player_entered(body: Node2D) -> void:
	player_is_there=true
	player=body
	#show tooltip : "press {key assigned to Interract} to open"


func _on_player_exited(body: Node2D) -> void:
	player_is_there=false
	player=body
	#hide tooltip
