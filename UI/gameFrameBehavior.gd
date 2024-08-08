func move_area(new_area):
	pass


# Declare member variables here.
var player
var enemies
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	add_enemies()
	get_player_details()

func add_enemies():
	pass # Add code to do this later

func get_player_details():
	pass
	# 
	# return [player.getType(),player.getPosition,[player.getHp(),player.getStamina()]] # 
	

# Called every frame.
func _process(delta):
	"""Delta is the dictionnary of the useful information of the game state, such as
	 the informations about the player, the ennemies ect"""
	process_inputs(delta)
	process_enemy_activity(delta)
	update_score()

func process_inputs(delta):
	pass
	# return 

func process_enemy_activity(delta):
	pass

func update_score():
	pass






























