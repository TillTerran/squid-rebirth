extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()


func hide_hp_fruit(fruit_number:int)->void:
	if fruit_number<5:
		$PanelContainer/HBoxContainer2/HBoxContainer/TextureRect5.hide()
		if fruit_number<4:
			$PanelContainer/HBoxContainer2/HBoxContainer/TextureRect4.hide()
			if fruit_number<3:
				$PanelContainer/HBoxContainer2/HBoxContainer/TextureRect3.hide()
				if fruit_number<2:
					$PanelContainer/HBoxContainer2/HBoxContainer/TextureRect2.hide()
					if fruit_number<1:
						$PanelContainer/HBoxContainer2/HBoxContainer/TextureRect.hide()
