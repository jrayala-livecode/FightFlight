extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var motion = Vector2()
export var MOVE_SPEED = 300
export var BULLET_SPEED = 350
export var LIFE = 1
export var SHOOT_PROBABILITY = 0.7
var accel
var velocity = Vector2(0,1)
var SCREEN_LIMIT_X 
var SCREEN_LIMIT_Y
var explosion = preload("res://Effects/Explosion.tscn")
var exp_sound = preload("res://SFX/SW001_8-Bit-Games-023_Explosion.wav")
var bullet = preload("res://Enemies/EnemyBullet.tscn")
var score = 10

func _ready():
	SCREEN_LIMIT_X = get_viewport().size.x
	SCREEN_LIMIT_Y = get_viewport().size.y

func hit():
	LIFE = LIFE - 1
	if LIFE <= 0:
		die()

func die():
	play_explosion()
	add_explosion()
	queue_free()
	add_to_player_score()

func add_to_player_score():
	get_tree().call_group("GUI","update_score",score)

func play_explosion():
	get_tree().call_group("SOUND","play_explosion")

func add_explosion():
	var explosion_instance = explosion.instance()
	explosion_instance.position = global_position
	get_tree().root.add_child(explosion_instance)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func seek(target):
	accel = (position + velocity).normalized() * MOVE_SPEED
	var desired_velocity = (target - position).normalized() * MOVE_SPEED
	var steering = desired_velocity - velocity
	return steering

func player_exists():
	return get_tree().root.get_node("Game").has_node("Player")

func get_player():
	return get_tree().root.get_node("Game").get_node("Player")

func get_vector_to_object(object):
	return (object.position - position)

func shoot():
	if player_exists():
		var vector_to_player = get_vector_to_object(get_player()).normalized()
		if $ShootTimer.is_stopped():
			$ShootTimer.start()
			var bullet_instance = bullet.instance()
			bullet_instance.position = position
			get_tree().root.add_child(bullet_instance)
			bullet_instance.add_force(Vector2(),vector_to_player * BULLET_SPEED)
