extends Area2D

var discussion_panel
@export var texts:PackedStringArray
@export var speakers:PackedStringArray
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVariables.can_swap_char:
		queue_free()
	else:
		discussion_panel=preload("res://menus/discussion_panel.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	GlobalVariables.can_swap_char=true
	var cur_discussion_panel = discussion_panel.instanciate()
	get_tree().current_scene.add_child(cur_discussion_panel)
	cur_discussion_panel.set_text(speakers,texts)
	queue_free()
