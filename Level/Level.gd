extends Node2D

var shake_amplitude = 0
onready var enemytimer = $EnemyTimer

var SCROLL_SPEED = 5
var motion = Vector2(0,1)

var easy_enemy_probability
var seeking_enemy_probability
var medium_enemy_probability

var playership = preload("res://Player/PlayerShip.tscn")
var easy_enemy = preload("res://Enemies/EasyEnemy.tscn")
var medium_enemy = preload("res://Enemies/MediumEnemy.tscn")
var dancing_enemy = preload("res://Enemies/DancingEnemy.tscn")
var playership_instance

var health_pack = preload("res://Items/1UP.tscn")
var rate_up = preload("res://Items/Rateup.tscn")
var bomb = preload("res://Items/Bomb.tscn")

var level = 1
var enemy_speed = 300
var started = false

func _ready():
	randomize()
	easy_enemy_probability = 0.3
	seeking_enemy_probability = 0.6
	medium_enemy_probability = 0.5
	$EnemyTimer.stop()

func start_game():
	$EnemyTimer.start()
	instance_player()
	started = true

func instance_player():
	playership_instance = playership.instance()
	add_child(playership_instance)

func restart_game():
	get_tree().reload_current_scene()

func _process(delta):
	motion.y += SCROLL_SPEED
	$Stars.scroll_offset = motion
	if(started):
		spawn_enemies()

func level_up():
	level = level + 1
	speed_up_enemies()
	speed_up_scroll()
	get_tree().call_group("GUI","update_level",level)
	roll_health_pack()
	roll_bullet_speed()
	roll_bomb()

func spawn_bomb(spawn_position):
	var bomb_instance = bomb.instance()
	add_child(bomb_instance)
	bomb_instance.global_position.x = spawn_position.x
	return bomb_instance

func roll_bomb():
	if level % 9 == 0 or level % 8 == 0 and randf() > 0.8:
		spawn_bomb(random_spawn_position())

func roll_health_pack():
	if level % 5 == 0 and randf() > 0.7:
		spawn_health_pack(Vector2(get_viewport().size.x / 2 , 0 ))

func roll_bullet_speed():
	if level % 3 == 0 and randf() > 0.5:
		spawn_rate_up(random_spawn_position())

func speed_up_enemies():
	enemy_speed += 1

func speed_up_scroll():
	SCROLL_SPEED += 0.1

func spawn_health_pack(spawn_position): 
	var health_pack_instance = health_pack.instance()
	add_child(health_pack_instance)
	health_pack_instance.global_position.x = get_viewport().size.x / 2
	return health_pack_instance

func spawn_enemies():
	if $EnemyTimer.is_stopped():
		$EnemyTimer.start()
		var enemy_probability = randf()
		var spawn_count = 1
		if(enemy_probability < easy_enemy_probability):
			spawn_easy_fleet(get_enemy_count() / spawn_count)
			spawn_count += 1
		
		if(enemy_probability < medium_enemy_probability):
			spawn_medium_fleet(get_enemy_count() /spawn_count )
			spawn_count += 1
		
		if(enemy_probability < seeking_enemy_probability):
			spawn_seeking_fleet(get_enemy_count() / spawn_count)
			spawn_count += 1
		

func get_enemy_count():
	var enemies = 0
	enemies = level % 10 +1
	if level > 1:
		enemies += level / 10
	return enemies


func spawn_easy_enemy(spawn_position): 
	var easy_enemy_instance = easy_enemy.instance()
	add_child(easy_enemy_instance)
	easy_enemy_instance.global_position = spawn_position
	easy_enemy_instance.MOVE_SPEED = enemy_speed
	return easy_enemy_instance

func spawn_dancing_enemy(spawn_position):
	var dancing_enemy_instance = dancing_enemy.instance()
	add_child(dancing_enemy_instance)
	dancing_enemy_instance.global_position = spawn_position
	dancing_enemy_instance.MOVE_SPEED = enemy_speed
	return spawn_position

func spawn_seeking_fleet(qty):
	for i in qty:
		spawn_dancing_enemy(random_spawn_position())

func spawn_easy_fleet(qty):
	for i in qty:
		spawn_easy_enemy(random_spawn_position())

func spawn_medium_fleet(qty):
	if qty > 0:
		for i in qty:
			spawn_medium_enemy(random_spawn_position())

func spawn_medium_enemy(spawn_position):
	var medium_enemy_instance = medium_enemy.instance()
	add_child(medium_enemy_instance)
	medium_enemy_instance.global_position = spawn_position
	medium_enemy_instance.MOVE_SPEED = enemy_speed
	return medium_enemy_instance

func random_spawn_position():
	randomize()
	var rand_x = randi() % int(get_viewport().size.x * 2)
	var rand_y = rand_range(0, -100)
	return Vector2(rand_x,rand_y)

func spawn_rate_up(spawn_position):
	var rate_up_instance = rate_up.instance()
	add_child(rate_up_instance)
	rate_up_instance.global_position = spawn_position
	return rate_up_instance

