extends Button




#func _physics_process(delta: float) -> void:
	#if is_pressed():
		#print("smth")
		#get_tree().quit()



func _pressed():
	print("smth")
	get_tree().quit()



