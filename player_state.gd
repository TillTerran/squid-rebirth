extends Node

var current_player_hp:int
var max_hp:int
var held_keys:int


var tile_length:int
var opened_doors:Array[bool]
var taken_keys:Array[bool]
var last_save_point:String

func _ready() -> void:
	last_save_point="res://levels/salle/Salle 01.tscn"
	opened_doors=[0,0,0,0]
	taken_keys=[0,0,0,0]
	tile_length=16
	pass

func change_save_point(new_save_point:String):
	last_save_point=new_save_point
