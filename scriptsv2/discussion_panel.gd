extends CanvasLayer

var text_array_number=-1
var visible_characters=-15.0
var monologue=false

@export var hundred_times_text_speed=75

var texts:PackedStringArray
var speakers:PackedStringArray
var moods:PackedStringArray
var speakers_hidden:Array[bool]

@onready var header=$"MarginContainer/VBoxContainer/VBoxContainer/quest panel/MarginContainer/GridContainer/header"
@onready var text_body= $"MarginContainer/VBoxContainer/VBoxContainer/quest panel/MarginContainer/GridContainer/RichTextLabel"
@onready var continue_quit_button=$"MarginContainer/VBoxContainer/VBoxContainer/quest panel/MarginContainer/GridContainer/Control/HBoxContainer/continue_or_quit"
@onready var skip_button=$"MarginContainer/VBoxContainer/VBoxContainer/quest panel/MarginContainer/GridContainer/Control/HBoxContainer/skip"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (texts.size()!=speakers.size()) and !monologue:
		push_error("the size of text_array cannot differ from speaker_array except for monologues")
	continue_quit_button.text="Next"
	continue_quit_button.disabled=true
	text_array_number=0
	text_body.visible_characters=0
	speakers_hidden=[]
	if texts.size()-1==text_array_number:
		continue_quit_button.text="Continue"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible_characters<len(text_body.text):
		visible_characters+=60*delta*hundred_times_text_speed/100
		if visible_characters>0:
			text_body.visible_characters=visible_characters
	else:
		continue_quit_button.disabled=false


func change_char_talking_texture(speaker:String="",mood:String="neutral"):
	if speaker=="":
		$MarginContainer/VBoxContainer/TextureRect2.set_texture(null)
		print("null")
	else:
		speaker=speaker.to_lower()
		if mood=="":
			mood="neutral"
		mood=mood.to_lower()
		$MarginContainer/VBoxContainer/TextureRect2.set_texture(load("res://menus/character_talking/"+speaker+"/"+speaker+"_"+mood+".png"))
		print("res://menus/character_talking/"+speaker+"/"+speaker+"_"+mood+".png")
	pass

func set_speakers_hidden(hidden_speakers_array:Array[bool]):
	speakers_hidden=hidden_speakers_array.duplicate()

func set_text(speaker_array:PackedStringArray,text_array:PackedStringArray,mood_array=null,speaker_name_unknown:Array[String]=["null"]):
	speakers=speaker_array
	texts=text_array
	if mood_array!=null:
		moods=mood_array
	else:
		var list1:Array[String]= []
		list1.resize(texts.size())
		list1.fill("")
		moods=PackedStringArray(list1)
	speakers_hidden.resize(texts.size())
	speakers_hidden.fill(false)


func _on_skip_pressed() -> void:
	get_tree().paused=false
	Events.loading_screen=false
	queue_free()


func _on_continue_or_quit_pressed() -> void:
	print(speakers_hidden)
	text_array_number+=1
	visible_characters=1.0
	text_body.visible_characters=0
	continue_quit_button.disabled=true
	if texts.size()>text_array_number:
		text_body.text=texts[text_array_number]
		if speakers_hidden[text_array_number]:
			header.text="???"
		else:
			header.text=speakers[text_array_number]
		change_char_talking_texture(speakers[text_array_number],moods[text_array_number])
	else:
		get_tree().paused=false
		Events.loading_screen=false
		get_parent().remove_child(self)
		queue_free()
	if texts.size()-1==text_array_number:
		continue_quit_button.text="Continue"
	
	
