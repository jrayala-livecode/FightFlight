extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var motion = Vector2()
var current_cannon = 1
onready var camera = get_tree().root.find_node("Camera")

var SPEED = 1100
const BULLET_SPEED = 8000
onready var SCREEN_LIMIT = get_viewport().size.x

var bullet = preload("res://Player/Bullet.tscn")
var explosion = preload("res://Effects/Explosion.tscn")
var invulnerable = false

export var LIFE = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.y = get_viewport().size.y - 30
	global_position.x = get_viewport().size.x / 2
	$AudioStreamPlayer.play()
	get_tree().call_group("GUI","update_lives",LIFE)


func _physics_process(delta):
	check_limits()
	## keyboard
	if Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		move_left()
	elif Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
		move_right()
	else:
		stay_still()
	if Input.is_action_pressed("up") or Input.is_mouse_button_pressed(BUTTON_LEFT):
		fire()
	## mouse
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mouse_position = get_viewport().get_mouse_position()
		motion.x = (mouse_position - position).normalized().x
	move_and_slide(motion * SPEED)

func check_limits():
	if position.x > SCREEN_LIMIT:
		position.x = SCREEN_LIMIT
	if position.x < 0:
			position.x = 1

func move_left():
	motion.x = -1

func move_right():
	motion.x = 1

func stay_still():
	motion.x = 0

func fire():
	if $Bullet_rate.is_stopped():
		$Bullet_rate.start()
		var bullet_instance = bullet.instance()
		bullet_instance.position = get_cannon().global_position
		get_tree().root.add_child(bullet_instance)
		bullet_instance.add_force(Vector2(), Vector2(0,-1 * BULLET_SPEED))

func get_cannon():
	if current_cannon == 1:
		current_cannon = 2
		return $"Cannon 1"
	else:
		current_cannon = 1
		return $"Cannon 2"

func hit():
	if not invulnerable:
		set_invulnerable()
		get_tree().call_group("CAMERA","shake")
		LIFE = LIFE - 1
		if LIFE < 0:
			die()
			LIFE = 0
		get_tree().call_group("GUI","update_lives",LIFE)

func die():
	add_explosion()
	queue_free()
	get_tree().call_group("GUI","game_over")

func life_up():
	LIFE += 1
	get_tree().call_group("GUI","update_lives",LIFE)

func add_explosion():
	var explosion_instance = explosion.instance()
	explosion_instance.position = global_position
	get_tree().root.add_child(explosion_instance)

func set_invulnerable():
	invulnerable = true
	$AnimationPlayer.play("Invulnerable")
	$Invulnerability_Time.start()
	$CollisionPolygon2D.disabled = true

func _on_Invulnerability_Time_timeout():
	$CollisionPolygon2D.disabled = false
	invulnerable = false

func bullet_rate_up():
	var current_rate = $Bullet_rate.wait_time 
	var new_rate = current_rate * 0.95
	$Bullet_rate.wait_time = new_rate

