extends Node2D

@onready var collision_polygon_2d = $"terrain de test/CollisionPolygon2D"
@onready var polygon_2d = $"terrain de test/CollisionPolygon2D/Polygon2D"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var gravity_center_position = Vector2(300,180)

# Called when the node enters the scene tree for the first time.
func _ready():
	polygon_2d.polygon = collision_polygon_2d.polygon
	Events.changeLevel.connect(level_transition)#the signal is never emmited for now



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func level_transition():
	
	get_tree().paused=true
	await LevelTransition.fade_to_black()
#	get_tree().change_scene_to_packed(next_level)
	get_tree().paused=true
	LevelTransition.fade_from_black()









