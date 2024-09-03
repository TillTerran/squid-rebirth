extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.show_tooltip.connect(show_tooltip)
	Events.hide_tooltip.connect(hide_tooltip)
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func show_tooltip(text:String,object:Node2D):
	pass

func hide_tooltip(text:String,object:Node2D):
	queue_free()
