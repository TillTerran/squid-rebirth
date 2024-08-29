extends Node

@onready var animation_player = $AnimationPlayer

var previous_scene = ""

func _ready() -> void:
	self.visible=true
	fade_from_black()

func fade_from_black():
	animation_player.play("fade_from_black")
	await animation_player.animation_finished




func fade_to_black():
	animation_player.play("fade_to_black")
	previous_scene = get_tree().current_scene.scene_file_path
	await animation_player.animation_finished
