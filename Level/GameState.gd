extends Spatial

var enemy_count

func _ready():
	instance_PC()
	count_enemies()

func count_enemies():
	enemy_count = $Robots.get_child_count()

func instance_PC():
	var Player
	if Customisation.Player_character == "Male":
		Player = Customisation.male.instance()
	else:
		Player = Customisation.female.instance()
	
	add_child(Player)
	Player.transform = $PlayerStartPosition.transform


func remove_enemy():
	enemy_count -= 1
	if enemy_count < 1:
		get_tree().change_scene("res://GUI/Victory.tscn")
