extends "res://Enemies/EnemyTemplate.gd"

var point
var step_y = 100
var step_x = 100
var screen_center_x

func _ready():
	randomize()
	screen_center_x = get_viewport().size.x / 2
	point = get_next_point()
	$ShootTimer.start()

func _physics_process(delta):
	if(global_position.distance_to(point) < 5):
		point = get_next_point()
	check_collision()
	shoot()
	move_and_slide(dance())

func dance():
	return seek(point)

func randomize_pos_neg(number):
	return number * 1 if randf() < 0.5 else number * -1

func get_next_point():
	point = Vector2(screen_center_x + randomize_pos_neg(step_x), position.y + step_y)
	if global_position.x > screen_center_x:
		point = Vector2(0 + step_x, position.y + step_y)
	elif global_position.x < screen_center_x:
		point = Vector2(SCREEN_LIMIT_X - step_x, position.y + step_y)
	return point

func check_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.has_method("hit"):
			if not collision.collider.invulnerable:
				collision.collider.hit()
				die()


