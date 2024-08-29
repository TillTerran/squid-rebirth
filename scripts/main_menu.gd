extends MarginContainer
@onready var start_button = $CenterContainer/VBoxContainer/start_Button
@export var last_save_location:String

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(start)
	print(start_button.pressed.is_connected(start))
	#last_save_location=GlobalVariables.last_save_location
	pass # Replace with function body.
	


func start():
	print("start")
	get_tree().change_scene_to_file(last_save_location)
