extends KinematicBody2D

export var MOVE_SPEED = 300

func _ready():
	pass

func _physics_process(delta):
	move_and_slide(MOVE_SPEED * Vector2(0,1))
	check_collision()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func check_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.has_method("bullet_rate_up"):
			get_tree().call_group("SHIP","bullet_rate_up")
			get_tree().call_group("PICKUP","play_rateup")
			queue_free()
			return
