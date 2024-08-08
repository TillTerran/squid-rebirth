extends MarginContainer
@onready var start_button = $CenterContainer/VBoxContainer/start_Button
@export var first_level:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(start)
	print(start_button.pressed.is_connected(start))
	pass # Replace with function body.
	


func start():
	print("start")
	get_tree().change_scene_to_packed(first_level)


