extends Node2D

@onready var collision_polygon_2d = $murs/circle/CollisionPolygon2D
@onready var polygon_2d = $murs/circle/CollisionPolygon2D/Polygon2D
@onready var center_of_gravity = $center_of_gravity
@onready var player = $player
@onready var c_gravity_area = $"zones forces mvt/c_gravity_area"


@export var level_right:PackedScene
@export var level_left:PackedScene
@export var level_up:PackedScene
@export var level_down:PackedScene
@export var level_door1:PackedScene
@export var level_door2:PackedScene
@export var level_door3:PackedScene
@export var level_door4:PackedScene



var gravity_center_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	polygon_2d.polygon = collision_polygon_2d.polygon
	gravity_center_position = Vector2(center_of_gravity.position.x,center_of_gravity.position.y)
	
	Events.main_menu.connect(to_main_menu)
	Events.right_level.connect(change_level_right)
	Events.left_level.connect(change_level_left)
	Events.up_level.connect(change_level_up)
	Events.down_level.connect(change_level_down)
	Events.door1.connect(change_level_door1)
	Events.door2.connect(change_level_door2)
	Events.door3.connect(change_level_door3)
	Events.door4.connect(change_level_door4)



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


func change_level_right():
	await change_scene(level_right)


func change_level_left():
	await change_scene(level_left)


func change_level_up():
	await change_scene(level_up)


func change_level_down():
	await change_scene(level_down)


func change_level_door1():
	await change_scene(level_door1)


func change_level_door2():
	await change_scene(level_door2)


func change_level_door3():
	await change_scene(level_door3)


func change_level_door4():
	await change_scene(level_door4)
