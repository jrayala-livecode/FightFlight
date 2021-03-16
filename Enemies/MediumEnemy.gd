extends "res://Enemies/EnemyTemplate.gd"

onready var player = get_parent().get_node("Player")

var arrived = false
var target = Vector2(0,2)
var x_values = []
var has_gone_forward = false
var area_distance = 200
var speedup = 1.5
var y_step_size = 100
var VIEWPORT

func _ready():
	$AudioStreamPlayer2D.seek(randi() % int($AudioStreamPlayer2D.stream.get_length())) 
	VIEWPORT = get_viewport()
	div_screen(12)
	LIFE = 1
	score = 10
	target = random_target()

func _physics_process(delta):
	check_collision()
	var force = seek(target)
	if not player:
		force = go_forward() * MOVE_SPEED
	elif player_is_in_area() or has_gone_forward:
		has_gone_forward = true
		force = go_forward() * MOVE_SPEED * speedup
	elif position.distance_to(target) < 3:
		target  = random_target()
	move_and_slide(force)

func roll_shoot():
	if randf() > SHOOT_PROBABILITY:
		shoot()

func player_is_in_area():
	return position.distance_to(player.position) < area_distance

func random_target():
	var new_target = Vector2()
	new_target.x =  get_random_horizontal_screen_division()
	new_target.y = rand_range(global_position.y + y_step_size, SCREEN_LIMIT_Y)
	return new_target

func get_random_horizontal_screen_division():
	return x_values[randi() % x_values.size()]

func div_screen(divisions):
	for i in range(divisions):
		x_values.push_front(SCREEN_LIMIT_X / (i + 1))

func go_forward():
	return Vector2(0,1)

func check_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			if collision.collider:
				if not collision.collider.invulnerable:
					collision.collider.hit()
					die()
					return


