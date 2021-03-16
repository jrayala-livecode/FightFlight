extends "res://Enemies/EnemyTemplate.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var has_collided = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.seek(randi() % int($AudioStreamPlayer2D.stream.get_length()) )

func _physics_process(delta):
	if $RayCast2D.is_colliding() and not has_collided:
		has_collided = true
		MOVE_SPEED = MOVE_SPEED + 300
		shoot()
	move_and_slide(go_forward() * MOVE_SPEED)
	check_collision()


func go_forward():
	return Vector2(0,1)

func go_left():
	return Vector2(-1,0)

func go_right():
	return Vector2(1,0)

func check_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.has_method("hit"):
			if not collision.collider.invulnerable:
				collision.collider.hit()
				die()
				return
