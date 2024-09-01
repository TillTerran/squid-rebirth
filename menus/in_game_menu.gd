extends CanvasLayer

var player_is_dead=false
var loading_screen=false

func _ready() -> void:
	hide()


func _process(delta: float) -> void:
	if !loading_screen:
		show()

func player_died():
	$"in-game menu/MarginContainer/quest panel/MarginContainer/GridContainer/header".text="GAME-OVER"
	player_is_dead=true
	get_tree().paused=true
	GlobalVariables.current_player_hp=GlobalVariables.max_hp

func _on_continue_pressed() -> void:
	if player_is_dead:
		get_tree().change_scene_to_file(GlobalVariables.last_save_point)
		$"in-game menu/MarginContainer/quest panel/MarginContainer/GridContainer/header".text="PAUSED"
	hide()
	player_is_dead=false
	get_tree().paused=false


func _on_quit_pressed() -> void:
	GlobalVariables.current_player_hp=GlobalVariables.max_hp
	get_tree().change_scene_to_file(GlobalVariables.main_menu)
	hide()
	$"in-game menu/MarginContainer/quest panel/MarginContainer/GridContainer/header".text="PAUSED"
	get_tree().paused=false
