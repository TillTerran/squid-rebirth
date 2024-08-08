extends Node2D

@onready var c_circle = $"circle/CollisionPolygon2D"
@onready var s_circle = $"circle/CollisionPolygon2D/Polygon2D"



@onready var collision_polygon_2d = $"StaticBody2D/CollisionPolygon2D"
@onready var polygon_2d = $"StaticBody2D/CollisionPolygon2D/Polygon2D"

var gravity_center_position = Vector2(0,0)



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Events.main_menu.connect(to_main_menu)
	s_circle.polygon = c_circle.polygon
	polygon_2d.polygon = collision_polygon_2d.polygon


func to_main_menu():
	print('main')
	get_tree().change_scene_to_file("res://main_menu.tscn")







