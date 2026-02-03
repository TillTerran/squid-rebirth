extends Area2D


func _ready():
	pass

func _on_body_entered(body):
	body.gravity_point = self.gravity_point_center
	body.gravity =  self.gravity



func _on_body_exited(body):
	body.gravity_point=null
