extends Node

var hp:int
var max_hp:int
var held_keys:int

var opened_doors:Array[bool]
var taken_keys:Array[bool]

func _ready() -> void:
	opened_doors=[0,0,0,0]
	taken_keys=[0,0,0,0]
	pass
