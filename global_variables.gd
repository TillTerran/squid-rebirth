extends Node

const main_menu:String="res://menus/main_menu_good.tscn"
const tile_length:int=16


var is_monke : bool
var current_player_hp:int
var max_hp:int
var held_keys:int
var last_save_point:String

var visited_discussions:Array[bool]


var opened_doors:Array[bool]
var taken_keys:Array[bool]

func _ready() -> void:
	last_save_point="res://levels/salle/Salle 01.tscn"
	visited_discussions=[0,0,0,0,0,0,0]
	opened_doors=[0,0,0,0]
	taken_keys=[0,0,0,0]
	held_keys=0
	#tile_length=16
	current_player_hp=5
	max_hp=5
	is_monke = true
	pass

func change_save_point(new_save_point:String):
	last_save_point=new_save_point
