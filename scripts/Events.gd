extends Node

#signal main_menu


signal change_scene
signal open_door
signal player_died
signal show_tooltip
signal hide_tooltip

var tp_point_id=0
var loading_screen=false

func main_menu():
	get_tree().change_scene_to_file(GlobalVariables.main_menu)

func to_credits():
	get_tree().change_scene_to_file("res://menus/credits.tscn")
