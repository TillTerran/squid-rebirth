extends ScrollContainer

var Delta_t=0.0
var scroll_speed =200#scroll speed in pixels per second
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/HBoxContainer/Button.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if round(Delta_t*scroll_speed)<=get_v_scroll():
		Delta_t+=delta
		scroll_vertical=round(scroll_speed*Delta_t)
	else:
		vertical_scroll_mode=1
		$VBoxContainer/HBoxContainer/Button.show()
		pass


func _on_button_pressed() -> void:
	Events.main_menu()
