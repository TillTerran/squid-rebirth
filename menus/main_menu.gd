extends CanvasLayer

const first_level:String = "res://levels/salle/Salle 01.tscn"

func _ready():
	%continue_Button.pressed.connect(continue_pressed)
	%credits_Button.pressed.connect(Events.to_credits)
	%quit_Button.pressed.connect(quit_game)
	%start_Button.pressed.connect(start_pressed)
	%start_Button.grab_focus()
	

func continue_pressed()->void:
	startthegame()





func start_pressed():
	reset_game()
	startthegame()


func reset_game():
	print("reset_game")
	GlobalVariables._ready()
	GlobalVariables.last_save_point=first_level

func startthegame()->void:
	print("game_starts")
	Events.change_scene.emit(GlobalVariables.last_save_point)
	

func quit_game():
	get_tree().quit()
