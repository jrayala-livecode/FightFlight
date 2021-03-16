extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

var explosion = preload("res://Effects/Explosion.tscn")

func _ready():
	$AudioStreamPlayer.play()

func _physics_process(delta):
	if not $VisibilityNotifier2D.is_on_screen():
		queue_free()

func add_explosion():
	var explosion_instance = explosion.instance()
	explosion_instance.position = global_position
	get_tree().root.add_child(explosion_instance)

func _on_Area2D_body_entered(body):
	if body.has_method('hit'):
		body.hit()
		add_explosion()
		queue_free()
