extends KinematicBody

export var max_ammo = 5

var food_types = {}
var can_fire = true
var ammo = 0
var can_refill = false
var action_state = 0 # -1 is throw, 0 is move/idle, +1 is reload

var lives = 3
var character_type

const PROJECTILE_SPEED = 50

enum CHARACTER_TYPES {player, npc}

func _ready():
	food_types = FileGrabber.get_files("res://Projectiles/FoodTypes/")
	randomize()

func try_to_fire():
	if can_fire and ammo > 0:
		fire()
		can_fire = false
		$Timer.start()
		ammo -= 1
		update_GUI()
		action_state = -1

func fire():
	var random_food = food_types[randi() % food_types.size()]
	var projectile = load(random_food).instance()
	add_child(projectile)
	projectile.fired_by = character_type
	projectile.set_as_toplevel(true)
	projectile.global_transform = $Forward.global_transform
	var character_forward = global_transform.basis[2].normalized()
	projectile.linear_velocity = character_forward * PROJECTILE_SPEED
	


func _on_Timer_timeout():
	can_fire = true


func check_ammo():
	if ammo < max_ammo:
		return true

func update_GUI():
	get_tree().call_group("GUI", "refresh_AmmoCount", ammo)

	
func hurt(fired_by):
	if character_type != fired_by:
		lives -= 1
		$Hurt.play()
		check_lives()
	update_lives()

func update_lives():
	get_tree().call_group("GUI", "update_lives", lives)

func check_lives():
	if lives < 1:
		die()

func die():
	queue_free()

