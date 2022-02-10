extends KinematicBody

var can_fire = true
var food_types = {}
var lives = 3
var character_type

const PROJECTILE_SPEED = 50

enum CHARACTER_TYPES {player, npc}

func _ready():
	food_types = FileGrabber.get_files("res://Projectiles/FoodTypes/")
	randomize()
	character_type = CHARACTER_TYPES.npc

func _physics_process(delta):
	if $RayCast.is_colliding():
		try_to_fire()

func try_to_fire():
	if can_fire:
		fire()
		can_fire = false
		$Timer.start()

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

func hurt(fired_by):
	if character_type != fired_by:
		lives -= 1
		$Hurt.play()
		check_lives()

func check_lives():
	if lives < 1:
		die()

func die():
	queue_free()


