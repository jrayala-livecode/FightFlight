extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
onready var lives = $LivesContainer/GridContainer/Lives
onready var score = $ScoreContainer/GridContainer2/Score
onready var level = $Level/GridContainer3/Level

var started = false
var game_over = false

func _ready():
	score.text = "0"
	lives.text = "0"
	level.text = "1"
	$Title.show()

func update_score(new_score):
	var actual_score = int(score.text)
	new_score = actual_score + int(new_score)
	score.text = str(new_score)
	if int(new_score) % int(100) == 0:
		$AudioStreamPlayer.stream = load("res://SFX/score_up.wav")
		$AudioStreamPlayer.play()
		get_tree().call_group("GAME","level_up")

func update_lives(new_lives):
	lives.text = str(new_lives)

func update_level(new_level):
	level.text = str(new_level)

func start_game():
	started = true
	$Title.hide()
	get_tree().call_group("GAME","start_game")

func game_over():
	$"Game Over".show()
	game_over = true

func _input(event):
	if Input.is_action_just_pressed("fire") || Input.is_action_just_pressed("up"):
		if not started:
			start_game()
		if game_over:
				get_tree().call_group("GAME","restart_game")
