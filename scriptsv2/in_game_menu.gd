extends CanvasLayer

var player_is_dead:bool=false
var new_pause:bool=true
@onready var header = $"in-game menu/MarginContainer/quest panel/MarginContainer/GridContainer/VBoxContainer/header"
#var loading_screen:bool=false

func _ready() -> void:
	hide()
	Events.player_died.connect(player_died)
	Events.loading_screen=false
	player_is_dead=false
	header.text="PAUSED"



func _process(_delta: float) -> void:
	if new_pause :
		$"in-game menu/MarginContainer/quest panel/MarginContainer/GridContainer/HBoxContainer/Continue".grab_focus()
		new_pause=false
	if !Events.loading_screen:
		show()

func player_died():
	header.text="GAME OVER"
	player_is_dead=true
	get_tree().paused=true
	GlobalVariables.current_player_hp=GlobalVariables.max_hp

func _on_continue_pressed() -> void:
	if player_is_dead:
		get_tree().change_scene_to_file(GlobalVariables.last_save_point)
		header.text="PAUSED"
	else:
		get_tree().paused=false
	hide()
	new_pause=true
	player_is_dead=false
	#get_tree().paused=false


func _on_quit_pressed() -> void:
	new_pause=true
	GlobalVariables.current_player_hp=GlobalVariables.max_hp
	Events.main_menu()
	#get_tree().paused=false
