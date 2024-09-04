extends CanvasLayer

var text_array_number=0
var visible_characters=-15.0
var monologue=false

@export var hundred_times_text_speed=50

@onready var header=$"MarginContainer/quest panel/MarginContainer/GridContainer/header"
@onready var text_body= $"MarginContainer/quest panel/MarginContainer/GridContainer/text"
@onready var continue_quit_button=$"MarginContainer/quest panel/MarginContainer/GridContainer/Control/HBoxContainer/continue_or_quit"
@onready var skip_button=$"MarginContainer/quest panel/MarginContainer/GridContainer/Control/HBoxContainer/skip"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#hide()
	if (get_meta("text_array").size()!=get_meta("speaker_array").size()) and !monologue:
		push_error("the size of text_array cannot differ from speaker_array except for monologues")
	continue_quit_button.text="Next"
	continue_quit_button.disabled=true
	text_array_number=0
	text_body.visible_characters=0
	text_body.text=get_meta("text_array")[0]
	header.text=get_meta("speaker_array")[0]
	if get_meta("text_array").size()-1==text_array_number:
		$"MarginContainer/quest panel/MarginContainer/GridContainer/Control/HBoxContainer/continue_or_quit".text="Continue"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible_characters<len(text_body.text):
		visible_characters+=60*delta*hundred_times_text_speed/100
		if visible_characters>0:
			text_body.visible_characters=visible_characters
	else:
		$"MarginContainer/quest panel/MarginContainer/GridContainer/Control/HBoxContainer/continue_or_quit".disabled=false
	
	
	






func _on_skip_pressed() -> void:
	get_tree().paused=false
	queue_free()


func _on_continue_or_quit_pressed() -> void:
	text_array_number+=1
	visible_characters=-5.0
	text_body.visible_characters=0
	if get_meta("text_array").size()>text_array_number:
		
		text_body.text=get_meta("text_array")[text_array_number]
		header.text=get_meta("speaker_array")[text_array_number]
	else:
		get_tree().paused=false
		queue_free()
	if get_meta("text_array").size()-1==text_array_number:
		continue_quit_button.text="Continue"
	
	
