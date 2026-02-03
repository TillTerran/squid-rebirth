@tool
extends Area2D

@export var area:Vector2=Vector2.ONE*30
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape.size=area
	#if not Engine.is_editor_hint():
		#process_mode=PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$CollisionShape2D.shape.size=area
