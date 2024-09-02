extends ScrollContainer

var Delta_t=0.0
var scroll_speed =50#scroll speed in pixels per second
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if round(Delta_t*scroll_speed)<=get_v_scroll():
		Delta_t+=delta
		scroll_vertical=round(scroll_speed*Delta_t)
	else:
		vertical_scroll_mode=1
		pass
