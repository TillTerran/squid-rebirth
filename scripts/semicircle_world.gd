extends Node2D

@onready var collision_polygon_2d = $murs/circle/CollisionPolygon2D
@onready var polygon_2d = $murs/circle/CollisionPolygon2D/Polygon2D
@onready var center_of_gravity = $center_of_gravity
@onready var player = $player
@onready var c_gravity_area = $"zones forces mvt/c_gravity_area"





var gravity_center_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	polygon_2d.polygon = collision_polygon_2d.polygon
	gravity_center_position = Vector2(center_of_gravity.position.x,center_of_gravity.position.y)
	
	Events.main_menu.connect(to_main_menu)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func change_scene(new_scene) -> void:
	
	
	if new_scene is PackedScene:
		await $LevelTransition.fade_to_black()
		await get_tree().change_scene_to_packed(new_scene)
	elif new_scene is String:
		await $LevelTransition.fade_to_black()
		await get_tree().change_scene_to_file(new_scene)
	else:
		return
	
	$LevelTransition.fade_from_black()


func to_main_menu():
	await change_scene("res://main_menu.tscn")
